function InitMainViewportEvent(obj){
	obj.LoadEvent = function(args){
		obj.OEOrderListGridStore.load({});
		
		obj.btnDelete = Ext.getCmp('btnDelete');
		obj.btnDelete.on("click", obj.btnDelete_OnClick, obj);
		
		//屏蔽右键菜单
		Ext.getDoc().on("contextmenu",function(e){
			e.stopEvent();
		});
		//屏蔽退格键
		if(document.addEventListener){
			document.addEventListener("keydown",maskBackspace,true);
		}else{
			document.attachEvent("onkeydown",maskBackspace);
		}
		function maskBackspace(event){
			var event=event||window.event;
			var obj=event.target||event.srcElement;
			var keyCode=event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
			if(keyCode==8){
				if(obj!=null && obj.tagName!=null && (obj.tagName.toLowerCase()=="input" || obj.tagName.toLowerCase()=="textarea")){
					event.returnValue=true;
					if(Ext.getCmp(obj.id)){
						if(Ext.getCmp(obj.id).readOnly){
							if(event.preventDefault){
								event.preventDefault();
							}else{
								event.keyCode=0
								event.returnValue=false;
							}
						}
					}
				}else{
					if(event.preventDefault){
						event.preventDefault();
					}else{
						event.keyCode=0
						event.returnValue=false;
					}
				}
			}
		}
	};
	
	obj.btnDelete_OnClick = function(){
		var objRec = obj.OEOrderListGrid.getSelectionModel().getSelected();
		if (objRec != null) 
		{
			var OEItemID = objRec.get("OEItemID");
			if (OEItemID!='') return;
			obj.OEOrderListGridStore.remove(objRec);
		}
	}
}

function addOEORIByCPW(StepItemIDS)
{
	var objOEOrderSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysOrderList");
	var strRowData=objOEOrderSrv.GetOEOrdItemRowData(StepItemIDS);
	if (strRowData!='')
	{
		var arrRowData=strRowData.split(String.fromCharCode(2));
		for (var indRowData=arrRowData.length-1; indRowData >= 0; indRowData--)
		{
			var strColData=arrRowData[indRowData];
			if (strColData!='')
			{
				InsertRowToTable(strColData);
			}
		}
	}
	var objGrid = Ext.getCmp('OEOrderListGrid');
	if (objGrid)
	{
		objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
	}
}

function InsertRowToTable(strColData)
{
	var arrColData=strColData.split(String.fromCharCode(1));
	if (arrColData.length == 1)
	{
		ExtTool.alert("错误提示!",arrColData[0]);
		return;
	} else {
		if (strColData.length < 20)
		{
			ExtTool.alert("错误提示!","InsertRowToTable() 参数错误!");
			return;
		}
	}
	
	var objOEOrderListGrid = Ext.getCmp('OEOrderListGrid');
	var objStore = objOEOrderListGrid.getStore();
	var objRec = null;
	
	var itmNumber = 0;
	for (var indRec=0;indRec<objStore.getCount();indRec++)
	{
		objRec = objStore.getAt(indRec);
		if (parseInt(objRec.get("ItmNumber"))>itmNumber)
		{
			itmNumber = parseInt(objRec.get("ItmNumber"));
		}
	}
	itmNumber++;
	
	var RecordType = objStore.recordType;
	var RecordData = new RecordType({
		OEItemID: '',
		ItmNumber: itmNumber,
		ItmPriorityID: arrColData[0],
		ItmPriority: arrColData[1],
		ItmStartDate: '',
		ItmStartTime: '',
		ItmArcimID: arrColData[2],
		ItmArcim: arrColData[3],
		ItmFreqID: arrColData[4],
		ItmFreq: arrColData[5],
		ItmInstrucID: arrColData[6],
		ItmInstruc: arrColData[7],
		ItmQty: arrColData[8],
		ItmPackUomID: arrColData[9],
		ItmPackUom: arrColData[10],
		ItmExecuteTime: arrColData[11],
		ItmResume: arrColData[12],
		StepItemIDStr: arrColData[13]
    });
    objStore.insert(objStore.getCount(), RecordData);
    //objStore.insert(0, RecordData);
}

//CS程序获取新开医嘱列表
function getStepItemIDStr()
{
	var objOEOrderListGrid = Ext.getCmp('OEOrderListGrid');
	var objStore = objOEOrderListGrid.getStore();
	var objRec = null;
	var StepItemIDList = '';
	for (var indRec=0;indRec<objStore.getCount();indRec++)
	{
		objRec = objStore.getAt(indRec);
		
		var OEItemID = objRec.get("OEItemID");            //医嘱ID
		if (OEItemID!='') continue;
		StepItemIDStr = objRec.get("StepItemIDStr");
		if (StepItemIDStr=='') continue;
		
		if (StepItemIDList!='')
		{
			StepItemIDList = StepItemIDList + "," + StepItemIDStr;
		} else {
			StepItemIDList = StepItemIDStr;
		}
	}
	return StepItemIDList;
}
