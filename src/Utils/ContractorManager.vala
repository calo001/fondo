namespace App.Contractor {
    public delegate void OnError();

    public void set_wallpaper_by_contract (File file, OnError error) {
        try {
            var contract = get_contract();
            contract.execute_with_file(file);
        } catch (GLib.Error e) {
            error();
        }
    }

    private Granite.Services.Contract? get_contract() throws GLib.Error {
        var contracts = Granite.Services.ContractorProxy.get_contracts_by_mime("image/bmp;image/gif;image/jpeg;image/png;image/svg+xml;image/tiff");

        foreach(Granite.Services.Contract contract in contracts){
            if (contract.get_icon().to_string().contains ("preferences-desktop-wallpaper")) {
                return contract;
            }
        }
        return null;
    }
}