-module (rrdlib).
-export ([loadavd_rrd_create/0]).


loadavd_rrd_create() ->
    Pid = rrdtool:start(),
    rrdtool:create(Pid, "loadavg.rrd", 
        [
            {"loadavg5", 'GAUGE', [600, u, u]},
            {"loadavg10", 'GAUGE', [600, u, u]},
            {"loadavg15", 'GAUGE', [600, u, u]}
        ],
        [
            {'MAX', 0.5, 3, 3600}
        ]).