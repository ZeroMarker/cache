function InitviewScreenEvent(obj) {
	
	obj.LoadEvent = function(args) {
		obj.CTLoc.on("expand", obj.CTLoc_OnExpand, obj);
		obj.cboWard.on("expand", obj.cboWard_OnExpand, obj);
		obj.CTDoctor.on("expand", obj.CTDoctor_OnExpand, obj);
		//obj.btnTransferInpCard.on("click", btnTransferInpCard_OnClick, obj);
		obj.btnTransferFiles.on("click", obj.btnTransferFiles_OnClick, obj);
		obj.btnReadCard.on("click", obj.btnReadCard_OnClick, obj);
		//obj.btnReset.on("click", btnReset_OnClick, obj);
		obj.btnSave.on("click", obj.btnSave_OnClick, obj);
		obj.btnSaveAndPrint.on("click", obj.btnSaveAndPrint_OnClick, obj);
	};
	
	obj.CTLoc_OnExpand = function() {
		obj.CTLocStore.load({});
	};
	obj.cboWard_OnExpand = function() {
		obj.cboWardStore.load({});
	};
	obj.CTDoctor_OnExpand = function() {
		obj.CTDoctorStore.load({});
	};
}
