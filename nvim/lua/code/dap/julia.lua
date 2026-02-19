local dap = require('dap')

dap.adapters.julia_dbg = {
    type = "server",
    port = "${port}",
    executable = {
        command = "julia",
        args = {
            "--project=@nvim-lspconfig",
            "-e",
            [[
            using Sockets
            using DebugAdapter

            function redirect_to_files(dofunc, outfile, errfile)
                open(outfile, "w") do out
                    open(errfile, "w") do err
                        redirect_stdout(out) do
                            redirect_stderr(err) do
                                try
                                dofunc()
                                catch e
                                @error "Exception occured" error=(e, catch_backtrace())
                                exit(-1)
                                end
                            end
                        end
                    end
                end
            end

            redirect_to_files("/tmp/dap-julia-stdout.log","/tmp/dap-julia-stderr.log") do
                server_port = parse(Int, ARGS[1])
                @info "Starting debug session" server_port
                server = Sockets.listen(server_port)

                @info "Waiting for connection to be accepted"
                conn = Sockets.accept(server)
                debugsession = DebugAdapter.DebugSession(conn)

                @info "Runing the debug session"
                run(debugsession)
                close(conn)
                @info "Closing the debug session connection"
            end
            ]],
            "--",
            "${port}",
        },
    },
}

dap.configurations.julia = {
    {
        type = "julia_dbg",
        name = "Debug julia executable",
        request = "launch",
        program = "${file}",
        projectDir = "${workspaceFolder}",
        juliaEnv = "${workspaceFolder}",
        exitAfterTaskReturns = false,
        debugAutoInterpretAllModules = false,
        stopOnEntry = true,
        args = {},
    },
}
