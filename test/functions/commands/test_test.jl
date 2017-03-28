@testset "Test Function Tests" begin

  @test isdefined(Julz, :test) == true

  initial_dir = pwd()

  dummy_package = "$(dirname(@__FILE__))/../../../../JulzDummy"

  cp("dummy", dummy_package, remove_destination=true)

  cd(dummy_package)

  originalSTDERR = STDERR
  originalSTDOUT = STDOUT

  (errRead, errWrite) = redirect_stderr()
  (outRead, outWrite) = redirect_stdout()

  println("\ndummy start\n")
  did_break = false
  try
    Julz.test()
  catch
    did_break = true
  end
  println("dummy end")

  close(errWrite)
  close(outWrite)

  err_data = readavailable(errRead)
  out_data = readavailable(outRead)

  close(errRead)
  close(outRead)

  redirect_stderr(originalSTDERR)
  redirect_stdout(originalSTDOUT)

  cd(initial_dir)

  rm(dummy_package, force=true, recursive=true)

  @test contains(String(err_data), "INFO: JulzDummy tests passed")

  if did_break

    println(" ================================ ")
    println("  dummy broken test output (out)  ")
    println(" ================================ ")

    println(String(out_data))

    println(" ================================ ")
    println("  dummy broken test output (err)  ")
    println(" ================================ ")

    println(String(err_data))

    println(" ================================ ")
    println("  dummy broken test output (end)  ")
    println(" ================================ ")

  end

end
