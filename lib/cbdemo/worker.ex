defmodule Cbdemo.Worker do                                                                                                                                            
  use Cbserverapi                                                                                                                                                     

  def handle_info({{:"basic.deliver",_,_,_, "api.events", "ingress.event.netconn"},
                   {:amqp_msg,
                   {:P_basic, "application/protobuf",_,_,_,_,_,_,_,_,_,_,_,_,_},
                   protobufdata}
                  }, state) do

    %Cbprotobuf.CbEventMsg{
      env: %Cbprotobuf.CbEnvironmentMsg{
        endpoint: %Cbprotobuf.CbEndpointEnvironmentMsg{
          SensorHostName: sensorhostname,
          SensorId: sensorid
        },
      },
      header: %Cbprotobuf.CbHeaderMsg{
        process_pid: process_pid,
        process_create_time: process_create_time,
        process_md5: process_md5,
        process_path: process_path,
        timestamp: timestamp
      },
      network: %Cbprotobuf.CbNetConnMsg{
        ipv4Address: ipv4Address,
        ipv6HiPart: ipv6HiPart,
        ipv6LoPart: ipv6LoPart,
        outbound: outbound,
        port: port,
        protocol: protocol,
        utf8_netpath: utf8_netpath
      }, 
    } = Cbprotobuf.CbEventMsg.decode(protobufdata)

    ipstring = stringifyIP(ipv4Address,ipv6HiPart,ipv6LoPart)
    port = endifyport(port)
    process_guid = gen_uuid(sensorid, process_pid, process_create_time)
    Logger.info("#{sensorhostname}[#{sensorid}] for IP: #{ipstring}:#{port} #{process_guid} #{process_pid} #{process_path}")
    
    {:noreply, state}
  end

  def gen_uuid(sensorid, process_pid, process_create_time) do
    << bitstring :: size(128) >> = << sensorid :: size(32), process_pid :: size(32), process_create_time :: size(64) >>
    :io_lib.format('~32.16.0b', [bitstring])
    |> List.flatten
    |> List.insert_at(8, '-')
    |> List.insert_at(13, '-')
    |> List.insert_at(18, '-')
    |> List.insert_at(23, '-')
    |> to_string
  end

  def stringifyIP(ipv4Address, nil, nil) do
    << a :: size(8), b :: size(8), c :: size(8), d :: size(8) >> = << ipv4Address :: little-size(32) >>
    "#{a}.#{b}.#{c}.#{d}"
  end
  
  def stringifyIP(a, b, c) do
    inspect({a,b,c})
  end

  def endifyport(portnumber) do
    << a :: little-size(16) >> = << portnumber :: big-size(16) >>
    a
  end

end
