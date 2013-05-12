Facter.add("passenger_root") do
  setcode do
    Facter::Util::Resolution.exec('passenger-config --root')
  end
end
