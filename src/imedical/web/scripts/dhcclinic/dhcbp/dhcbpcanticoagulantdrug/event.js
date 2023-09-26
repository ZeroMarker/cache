function InitViewScreenEvent(obj)
{
	var SelectedRowID = 0;
	var preRowID=0;	
	var _DHCBPCAnticoagulantDrug=ExtTool.StaticServerObject('web.DHCBPCAnticoagulantDrug');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  SelectedRowID=rc.get("tID");
	  if (rc){ 
	  	if(preRowID!=SelectedRowID){
		    obj.Rowid.setValue(rc.get("tID"));
		    obj.drugCode.setValue(rc.get("tBPCADCode"));//药品Code
		    obj.drugName.setValue(rc.get("tBPCADDesc")); //药品名称
		    obj.totalAmount.setValue(rc.get("tBPCADAmount"));//总量
		    obj.FirstAmount.setValue(rc.get("tBPCADFirstAmount"));//首推量
		    obj.drugUnit.setValue(rc.get("tBPCADUomDr"));//单位
		    obj.drugDosage.setValue(rc.get("tBPCADDose"));//剂量
		    obj.drugConcentration.setValue(rc.get("tBPCADConcentration"));//浓度
		    obj.drugFrequency.setValue(rc.get("tBPCADFrequency"));//频率
		    obj.note.setValue(rc.get("tBPCADNote"));//备注
		    obj.ctlocdesc.setValue(rc.get("tBPCDeptId"))
		    obj.ctlocdesc.setRawValue(rc.get("tBPCDept"))  //科室
		    var bpcAMIdList=rc.get("tBPCAMIdList");
		    var bpcAMIdListArray=bpcAMIdList.split(",");
		    var bpcAMDescList=rc.get("tBPCAMDescList")
		    var bpcAMDescListArray=bpcAMDescList.split(",");
		    var setCombValue="";
			for(var i=0;i<bpcAMIdListArray.length;i++){
				if(setCombValue==""){
					setCombValue=bpcAMIdListArray[i]+"!"+bpcAMDescListArray[i];
				}else{
						setCombValue=setCombValue+","+bpcAMIdListArray[i]+"!"+bpcAMDescListArray[i];
				}
			}
		    obj.AnticoagulantMode.setDefaultValue(setCombValue); //抗凝方式
		 	preRowID=SelectedRowID;
		}else{
			obj.Rowid.setValue("")
		    obj.drugCode.setValue("");//药品Code
		    obj.drugName.setValue(""); //药品名称
		    obj.totalAmount.setValue("");//总量
		    obj.FirstAmount.setValue("");//首推量
		    obj.drugUnit.setValue("");//单位
		    obj.drugDosage.setValue("");//剂量
		    obj.drugConcentration.setValue("");//浓度
		    obj.drugFrequency.setValue("");//频率
		    obj.note.setValue("");//备注
		    obj.AnticoagulantMode.setValue("")//抗凝方式
		    obj.ctlocdesc.setValue("") //科室
			SelectedRowID = 0;
		    preRowID=0;
		};
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.drugCode.getValue()=="")
		{
			ExtTool.alert("提示","药品代码不能为空!");	
			return;
		}
		if(obj.drugName.getValue()=="")
		{
			ExtTool.alert("提示","药品名不能为空!");	
			return;
		}
		
		var BPCADCode=obj.drugCode.getValue();//药品Code
		var BPCADDesc=obj.drugName.getValue(); //药品名称
		var BPCADAmount=obj.totalAmount.getValue();//总量
		var BPCADFirstAmount=obj.FirstAmount.getValue();//首推量
		var BPCADUomDr=obj.drugUnit.getValue();//单位
		var BPCADDose=obj.drugDosage.getValue();//剂量
		var BPCADConcentration=obj.drugConcentration.getValue();//浓度
		var BPCADFrequency=obj.drugFrequency.getValue();//频率
		var BPCADNote=obj.note.getValue();//备注
		var bpcAMIdList=obj.AnticoagulantMode.getValue()//抗凝方式
		var bpclocId=obj.ctlocdesc.getValue(); //科室
		var bpcADInfoList=BPCADCode+"^"+BPCADDesc+"^"+BPCADAmount+"^"+BPCADConcentration+"^"+BPCADUomDr+"^"+BPCADFirstAmount+"^"+BPCADDose+"^"+BPCADFrequency+"^"+BPCADNote+"^"+bpcAMIdList+"^"+bpclocId
		//alert(bpcADInfoList);return
		var ret=_DHCBPCAnticoagulantDrug.InsertAnticoagulantDrug(bpcADInfoList);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	//obj.Rowid.setValue("");
		    obj.drugCode.setValue("");//药品Code
		    obj.drugName.setValue(""); //药品名称
		    obj.totalAmount.setValue("");//总量
		    obj.FirstAmount.setValue("");//首推量
		    obj.drugUnit.setValue("");//单位
		    obj.drugDosage.setValue("");//剂量
		    obj.drugConcentration.setValue("");//浓度
		    obj.drugFrequency.setValue("");//频率
		    obj.note.setValue("");//备注
		    obj.AnticoagulantMode.setValue("")//抗凝方式
		    obj.ctlocdesc.setValue("")//科室
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		//alert("gg")
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","ID不能为空!");	
			return;
		}		
		if(obj.drugCode.getValue()=="")
		{
			ExtTool.alert("提示","药品代码不能为空!");	
			return;
		}
		if(obj.drugName.getValue()=="")
		{
			ExtTool.alert("提示","药品名不能为空!");	
			return;
		}
		var Rowid=obj.Rowid.getValue();
		var BPCADCode=obj.drugCode.getValue();//药品Code
		var BPCADDesc=obj.drugName.getValue(); //药品名称
		var BPCADAmount=obj.totalAmount.getValue();//总量
		var BPCADFirstAmount=obj.FirstAmount.getValue();//首推量
		var BPCADUomDr=obj.drugUnit.getValue();//单位
		var BPCADDose=obj.drugDosage.getValue();//剂量
		var BPCADConcentration=obj.drugConcentration.getValue();//浓度
		var BPCADFrequency=obj.drugFrequency.getValue();//频率
		var BPCADNote=obj.note.getValue();//备注
		var bpcAMIdList=obj.AnticoagulantMode.getValue()//抗凝方式
		var bpclocId=obj.ctlocdesc.getValue(); //科室
		var bpcADInfoList=Rowid+"^"+BPCADCode+"^"+BPCADDesc+"^"+BPCADAmount+"^"+BPCADConcentration+"^"+BPCADUomDr+"^"+BPCADFirstAmount+"^"+BPCADDose+"^"+BPCADFrequency+"^"+BPCADNote+"^"+bpcAMIdList+"^"+bpclocId
		//alert(bpcADInfoList)
       
		var ret=_DHCBPCAnticoagulantDrug.UpdateAnticoagulantDrug(bpcADInfoList);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	//obj.Rowid.setValue("");
		    obj.drugCode.setValue("");//药品Code
		    obj.drugName.setValue(""); //药品名称
		    obj.totalAmount.setValue("");//总量
		    obj.FirstAmount.setValue("");//首推量
		    obj.drugUnit.setValue("");//单位
		    obj.drugDosage.setValue("");//剂量
		    obj.drugConcentration.setValue("");//浓度
		    obj.drugFrequency.setValue("");//频率
		    obj.note.setValue("");//备注
		    obj.AnticoagulantMode.setValue("")//抗凝方式
		    obj.ctlocdesc.setValue("")//科室
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.Rowid.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCAnticoagulantDrug.DeleteAnticoagulantDrug(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	//obj.Rowid.setValue("");
		    obj.drugCode.setValue("");//药品Code
		    obj.drugName.setValue(""); //药品名称
		    obj.totalAmount.setValue("");//总量
		    obj.FirstAmount.setValue("");//首推量
		    obj.drugUnit.setValue("");//单位
		    obj.drugDosage.setValue("");//剂量
		    obj.drugConcentration.setValue("");//浓度
		    obj.drugFrequency.setValue("");//频率
		    obj.note.setValue("");//备注
		    obj.AnticoagulantMode.setValue("")//抗凝方式
	  	  	obj.retGridPanelStore.load({}); 
		  	});

	  	}
	  );
	};
}