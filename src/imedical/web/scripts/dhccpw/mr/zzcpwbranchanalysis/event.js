
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
			ExtTool.alert("��ʾ","��ѡ����Ҫ�������Ŀ");
			return;	
		}
		if (CurrentTitleId==""){
			ExtTool.prompt("����Ϊ","������ͳ������",function(btn, newName){
				if (btn == "ok") {
						//if (newName=="") return;
						if (newName==""){
							alert("ͳ�����Ʋ���Ϊ��");	//	Modified by zhaoyu 2012-11-14
							return;
						}
						//ExtTool.alert("",newName);
						SaveTitle("",newName,Items);
						obj.cboStatTitleStore.load({});	//	Add by zhaoyu 2012-11-14 ��ѯͳ��-��֧���ٴ�·��ͳ��-������ͳ�����⡿��ͳ�������б��в��Զ�ˢ�� ȱ�ݴ���193
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
			ExtTool.alert("��ʾ","����ɹ�!");
		}
		else{
			ExtTool.alert("error","����ʧ��,�������="+ret);
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
		//	*******Modified by zhaoyu 2012-11-14 ��ѯͳ��--��֧���ٴ�·��ͳ��-��ѡ��·����ֻѡ�񡾲������͡��������>>��Ҳ������ӳɹ� ȱ�ݱ��200
		var Shoot=ItemDesc.split("+");
		Shoot=Shoot[0].split("(");
		if (Shoot[0]==""){
			alert("��ѡ��·����");
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
			ExtTool.alert("��ʾ","��ѡ����Ҫͳ�Ƶ���Ŀ");
			return;	
		}
		obj.GridPanelStore.load({params:{Arg3:Items}});
	}
	obj.btnExport_OnClick = function()
	{
		var strFileName="��֧��·��ͳ��";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.GridPanel,strFileName);
	}
	function BuildStr(){
		//ȡ·������ɴ�
		var strCPWDesc=obj.cboOffShoot.getRawValue();
		var newStr = strCPWDesc;
		var keyStr = obj.cboOffShoot.getValue()+"|";
		//ȡ������ɴ�
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
		//ȡ�ϲ�֢��ɴ�
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