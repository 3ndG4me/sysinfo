import common, strutils, osproc

proc tryParseInt(s: string): int =
  try:
    result = parseInt(s)
  except ValueError:
    result = 0

proc tryParseUInt64(s: string): uint64 =
  try:
    result = parseBiggestUInt(s)
  except ValueError:
    result = 0'u64

proc powershell(query: string): string =
  let (outp, _) = execCmdEx("powershell -NoProfile -Command " & query)
  return outp.strip().splitLines[^1].strip()

proc getMachineGuid*(): string =
  powershell("(Get-CimInstance -Class Win32_ComputerSystemProduct).UUID")

proc getMachineModel*(): string =
  powershell("(Get-CimInstance -Class Win32_ComputerSystem).Model")

proc getMachineName*(): string =
  powershell("(Get-CimInstance -Class Win32_ComputerSystem).Name")

proc getMachineManufacturer*(): string =
  powershell("(Get-CimInstance -Class Win32_ComputerSystem).Manufacturer")

proc getOsName*(): string =
  powershell("(Get-CimInstance -Class Win32_OperatingSystem).Name.Split('|')[0]")

proc getOsVersion*(): string =
  powershell("(Get-CimInstance -Class Win32_OperatingSystem).Version")

proc getOsSerialNumber*(): string =
  powershell("(Get-CimInstance -Class Win32_OperatingSystem).SerialNumber")

proc getCpuName*(): string =
  powershell("(Get-CimInstance -Class Win32_Processor).Name")

proc getCpuManufacturer*(): string =
  powershell("(Get-CimInstance -Class Win32_Processor).Manufacturer")

proc getNumCpus*(): int =
  tryParseInt(powershell("(Get-CimInstance -Class Win32_ComputerSystem).NumberOfProcessors"))

proc getNumTotalCores*(): int =
  tryParseInt(powershell("(Get-CimInstance -Class Win32_ComputerSystem).NumberOfLogicalProcessors"))

proc getCpuGhz*(): float =
  try:
    parseFloat(powershell("(Get-CimInstance -Class Win32_Processor).MaxClockSpeed")) / 1000.0
  except ValueError:
    0.0

proc getTotalMemory*(): uint64 =
  tryParseUInt64(powershell("(Get-CimInstance -Class Win32_ComputerSystem).TotalPhysicalMemory"))

proc getFreeMemory*(): uint64 =
  (tryParseUInt64(powershell("(Get-CimInstance -Class Win32_OperatingSystem).FreePhysicalMemory"))) * 1024

proc getGpuName*(): string =
  powershell("(Get-CimInstance -Class Win32_VideoController)[0].Name")

proc getGpuDriverVersion*(): string =
  powershell("(Get-CimInstance -Class Win32_VideoController)[0].DriverVersion")

proc getGpuMaxFPS*(): int =
  tryParseInt(powershell("(Get-CimInstance -Class Win32_VideoController)[0].MaxRefreshRate"))
