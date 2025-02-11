local OS = require('common.os').OS

local PackageManagerType = {
  Nix = 'nix-env',
  APT = 'apt',
  Scoop = 'scoop',
  HomeBrew = 'brew',
}

local InstallCommands = {
  [PackageManagerType.Nix] = '-i',
  [PackageManagerType.APT] = 'install -y',
  [PackageManagerType.Scoop] = 'install',
  [PackageManagerType.HomeBrew] = 'install',
}

local PackageManagerByOS = {
  [OS.Linux] = { PackageManagerType.Nix, PackageManagerType.APT },
  [OS.Windows] = { PackageManagerType.Scoop },
  [OS.Mac] = { PackageManagerType.HomeBrew },
  [OS.Unknown] = {},
}

return {
  PackageManagerType = PackageManagerType,
  InstallCommands = InstallCommands,
  AvailablePackageManagers = PackageManagerByOS[require('common.os').os_type()],
}
