
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
	
  { 
  	obj.GridPanel4Store.load();
  	
  	};
	obj.B_Save_click = function()
	{
		SaveData()
	};
	;
	obj.B_Clear_click = function()
	{
		ClearFrm()
	};
	obj.TblTree_click=function()
	{
		SetCodeType()
	};
	obj.GridPanel_rowclick = function()
	{
		obj.EditProduct();
	}
	obj.GridPanel_cellclick=function(g,row,col,e)
	{
		obj.GridPanel4_cellclick(g,row,col,e);
	}
/*Viewport1��������ռλ��*/




	function ClearFrm(){
		obj.CLCode.setValue("");
		obj.CLDesc.setValue("");
		obj.CLExpandCode.setValue("");
		obj.CLRemark.setValue("");
		obj.CLActive.setValue(true);
		obj.Rowid.setValue("");
		obj.CLCode.focus(true,3);
	}

	function SaveData(){
		if (obj.CLType.getValue()=="")
		{
			ExtTool.alert("��ʾ", "��ѡ��Ҫά������Ŀ!");
			return;
			}
		if(!obj.FormPanel14.getForm().isValid()) {
			ExtTool.alert("��ʾ","��������");
			return;
		}
		var Instr="CLActive^CLCode^CLDesc^CLExpandCode^CLRemark^CLType"
		var Valuestr=ExtTool.GetValuesByIds(Instr);
		
		var cacheobj=ExtTool.StaticServerObject("web.DHCHM.HMCodeConfig");
		var IDstr=obj.Rowid.getValue()
		//alert(Valuestr);
		var ret=cacheobj.SaveClaLevel(IDstr,Valuestr)
	  var infoStr=ret.split("^");
	  if (infoStr[0]!="-1") {
	  	//ExtTool.alert("��ʾ", "����ɹ�!"); 
	  	ClearFrm(); 	
		}
		else{
			ExtTool.alert ("��ʾ", infoStr[1]);
		}
		obj.GridPanel4Store.load();
	}
	
	function SetCodeType(){
		// �õ�ѡ�еĽڵ�
		var selectedNode = obj.TypeTree.getSelectionModel().getSelectedNode();
    
    var tmpid = selectedNode.attributes.id;
    var tmpname = selectedNode.attributes.text;

		if (tmpid!="0"){
			obj.CLType.setValue(tmpid);
			obj.main.setTitle(tmpname);
		}
		
		//���
		ClearFrm();
		//����չ��
		obj.GridPanel4Store.load();
		
	}
	
	obj.EditProduct = function(){
		
		var selectObj = obj.GridPanel4.getSelectionModel().getSelected();
		//alert(selectObj);
		if (selectObj){
			
			obj.CLCode.setValue(selectObj.get("CLCode"));
			obj.CLDesc.setValue(selectObj.get("CLDesc"));
			obj.CLExpandCode.setValue(selectObj.get("CLExpandCode"));
			obj.CLRemark.setValue(selectObj.get("CLRemark"));
			obj.CLActive.setValue(selectObj.get("CLActive"));
			if(selectObj.get("CLActive")=="true"){obj.CLActive.setValue("1")};
			else{obj.CLActive.setValue("0")};
			obj.Rowid.setValue(selectObj.get("ID"));
			
		}
		else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}		
	};
	
	obj.GridPanel4_cellclick = function(g,row,col,e)
	{
		var fieldName = g.getColumnModel().getDataIndex(col);
		if(fieldName!='EditExpression') return;
		var objWindowEx = new InitWindowEx();
		objWindowEx.WindowEx.show();
		var record=g.getStore().getAt(row);
		var ID=record.get("ID");
		objWindowEx.ESourceID.setValue(ID);
		var EType="2001";
		EType=EType+obj.CLType.getValue();
		//alert(EType);
		objWindowEx.EType.setValue(EType);
		objWindowEx.GridPanelExStore.load();
	};
}












































































































































































































































































