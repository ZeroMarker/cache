
function InitBranchMonitorViewportEvent(obj)
{
	var ItemDesc,Key;
	var CurrentTitleId="";
	obj.LoadEvent = function(args)
	{
		obj.cboOffShoot.on("select", obj.cboOffShoot_OnExpand, obj);
		obj.btnAnalysis.on("click",obj.btnAnalysis_OnClick,obj);
		obj.btnAdd.on("click",obj.btnAdd_OnClick,obj)
		obj.btnSave.on("click",obj.btnSave_OnClick,obj)
		obj.btnClear.on("click",obj.btnClear_OnClick,obj)
		obj.cboStatTitle.on("select", obj.cboStatTitle_OnExpand, obj);
		obj.btnExport.on("click",obj.btnExport_OnClick,obj)
	}
	
	obj.btnSave_OnClick = function(){
		var Items=BuildTitle();
		if (Items=="") {
			ExtTool.alert("提示","请选择需要保存的项目");
			return;	
		}
		if (CurrentTitleId==""){
			ExtTool.prompt("保存为","请输入统计名称",function(btn, newName){
				if (btn == "ok") {
						//if (newName=="") return;
						if (newName==""){
							alert("统计名称不能为空");	//	Modified by zhaoyu 2012-11-14
							return;
						}
						//ExtTool.alert("",newName);
						SaveTitle("",newName,Items);
						obj.cboStatTitleStore.load({});	//	Add by zhaoyu 2012-11-14 查询统计-分支型临床路径统计-新增【统计主题】后，统计主题列表中不自动刷新 缺陷代码193
				} else {
					return;
				}
			});
		}
		else{
			SaveTitle(CurrentTitleId,"",Items);
		}
	}
	BuildTitle = function(){
		var Items="";
		for (var rowIndex=0; rowIndex<obj.OffShootStatTitleStore.getCount();rowIndex++ )
		{
			var objRec=obj.OffShootStatTitleStore.getAt(rowIndex);
			var IsChecked=objRec.get("checked");
			
			if (IsChecked)
			{
				Items+=objRec.get("Key");
				Items+="|";
				Items+=objRec.get("ItemDesc");
				Items+=String.fromCharCode(1);
			}
		}
		return Items;
	}
	SaveTitle = function(TitleId,Title,Items){
		var objSrc=ExtTool.StaticServerObject("web.DHCCPW.MR.BranchAnalysis")
		var ret = objSrc.SaveTitle(TitleId,Title,Items);
		if(ret > 0)
		{
			ExtTool.alert("提示","保存成功!");
		}
		else{
			ExtTool.alert("error","保存失败,错误代码="+ret);
			}
	}
		
	obj.cboOffShoot_OnExpand = function(){
		//obj.StepStore.load({});
	}
	obj.cboStatTitle_OnExpand = function(){
		CurrentTitleId=obj.cboStatTitle.getValue();
		obj.OffShootStatTitleStore.load({params:{Arg1:CurrentTitleId}});
	}
	obj.btnClear_OnClick = function(){
	  CurrentTitleId="";
	  obj.cboStatTitle.setValue("");
	  obj.cboStatTitle.setRawValue("");
		obj.OffShootStatTitleStore.removeAll();
	}
	obj.btnAdd_OnClick = function()
	{
		var str = BuildStr();
		record=new Ext.data.Record({
			Index:0,
			ItemDesc:ItemDesc,
			Key:Key
			});
		//	*******Modified by zhaoyu 2012-11-14 查询统计--分支型临床路径统计-不选择【路径】只选择【步骤类型】，点击【>>】也可以添加成功 缺陷编号200
		var Shoot=ItemDesc.split("+");
		Shoot=Shoot[0].split("(");
		if (Shoot[0]==""){
			alert("请选择路径！");
		}else{
			obj.OffShootStatTitleStore.add(record);
		}
		//obj.OffShootStatTitleStore.add(record);
		//	*******
	}
	obj.btnAnalysis_OnClick = function()
	{
		var Items=BuildTitle();
		if (Items=="") {
			ExtTool.alert("提示","请选择需要统计的项目");
			return;	
		}
		obj.GridPanelStore.load({params:{Arg3:Items}});
	}
	obj.btnExport_OnClick = function()
	{
		var strFileName="分支型路径统计";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.GridPanel,strFileName);
	}
	function BuildStr(){
		//取路径名组成串
		var strCPWDesc=obj.cboOffShoot.getRawValue();
		var newStr = strCPWDesc;
		var keyStr = obj.cboOffShoot.getValue()+"|";
		//取步骤组成串
		var objStore=obj.StepGrid.getStore();
		var StepDesc='';
		for (var rowIndex=0; rowIndex<objStore.getCount();rowIndex++ )
		{
			var objRec=objStore.getAt(rowIndex);
			var IsChecked=objRec.get("checked");
			
			if (IsChecked)
			{
				if (StepDesc=='')
				{
					StepDesc='('+objRec.get('StepDesc');
					keyStr =keyStr+objRec.get('DicCode')
				}
				else {
					StepDesc=StepDesc+'+'+objRec.get('StepDesc');
					keyStr =keyStr+"^"+objRec.get('DicCode')
				}
			}
		}
		if (StepDesc!='')
		{
			StepDesc=StepDesc+')';
		}
		newStr=newStr+StepDesc;
		keyStr =keyStr+"|";
		//取合并症组成串
		var objStore=obj.SyndromeGrid.getStore();
		var SyndromeDesc='';
		for (var rowIndex=0; rowIndex<objStore.getCount();rowIndex++ )
		{
			var objRec=objStore.getAt(rowIndex);
			var IsChecked=objRec.get("checked");
			if (IsChecked)
			{
				if (SyndromeDesc=='')
				{
					SyndromeDesc='('+objRec.get('CPWDDesc');
					keyStr =keyStr+objRec.get('Rowid')
				}
				else {
					SyndromeDesc=SyndromeDesc+'+'+objRec.get('CPWDDesc');
					keyStr =keyStr+"^"+objRec.get('Rowid')
				}
			}
		}
		if (SyndromeDesc!='')
		{
			SyndromeDesc=SyndromeDesc+')';
			newStr=newStr+'+'+SyndromeDesc;
		}
		ItemDesc=newStr;
		Key=keyStr;
		
		return newStr;
	}
}