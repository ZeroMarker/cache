/*      Desc: ����ԭ������桾�ֵ����������ƣ�PMP.Dictionary3 
    Function: ����ԭ������水ť�¼�
      Author��liubaoshi
        Date: 2015-04-02
*/
function InitViewportEvent(obj) {	
	obj.LoadEvent = function(){};
	//����
	obj.btnSave_click = function()	
	{	
		var selectObj = obj.gridList.getSelectionModel().getSelected();	
		var Id=""
		if(selectObj){	
			var Id=selectObj.get("RowID")
		}
		var bodyCode=obj.bodyCode.getValue();	//����
		var bodyDesc=obj.bodyDesc.getValue();	//����
		var bodyNote=obj.bodyNote.getValue();	//��ע
		var bodyType=obj.bodyType.getValue();	//����
		var bodyStr=bodyType+"^"+bodyCode+"^"+bodyDesc+"^"+bodyNote+"^"+Id+"^"+"Insert";
		alert(bodyStr);
		if(bodyType==""||bodyCode==""||bodyDesc==""){
			ExtTool.alert("��ʾ","���͡����롢��������Ϊ��!");
			return;
		}
		var bodyOBJ = ExtTool.StaticServerObject("web.PMP.PMPDictionary");	
		var ret = bodyOBJ.Update(bodyStr);
		if (ret==9){   //ԭ���򷵻�9Ϊ�ɹ�
			ExtTool.alert("��ʾ","����ɹ�!");
		}else{
			ExtTool.alert("��ʾ","���ʧ��!");
		}
		obj.clear(); 
	};
	obj.bodyCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.btnSch_click();
	};
	};
	obj.bodyDesc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.btnSch_click();
	};
	};
	obj.bodyNote_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.btnSch_click();
	};
	};
	obj.bodyType_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.btnSch_click();
	};
	};
	//ɾ����ԭ��ɾ�Ĳ���������׸,����DelInfo������
	/*
	obj.btnDel_click  = function(){
	    //alert("ɾ��??");{return}
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			Ext.MessageBox.show({
		    	title:'��ʾ',
		    	msg:'��ȷ��Ҫɾ��ô��',
		    	modal:true,
		    	width:260,
				fn:callBack,
		    	icon:Ext.Msg.INFO,
		    	buttons:Ext.Msg.OKCANCEL	
				//buttons:Ext.Msg.YESNOCANCEL
			});
			function callBack(btn){
				if(btn=="ok"){
					var DelOBJ = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
					var ret = DelOBJ.DelInfo(selectObj.get("RowID"));
					if (ret==0){
						ExtTool.alert("��ʾ","ɾ���ɹ�!");
					}else{
						ExtTool.alert("��ʾ","ɾ��ʧ��!");
					}
					obj.clear();
				}		
			}  
		}else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}
	};
	*/
	//ɾ��
	obj.btnDel_click  = function(){
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			Ext.MessageBox.show({
		    	title:'��ʾ',
		    	msg:'��ȷ��Ҫɾ��ô��',
		    	modal:true,
		    	width:260,
				fn:callBack,
		    	icon:Ext.Msg.INFO,
				//icon : Ext.Msg.WARNING,
		    	buttons:Ext.Msg.OKCANCEL	
				//buttons:Ext.Msg.YESNOCANCEL
			});
			function callBack(btn){
				if(btn=="ok"){
					var Id=selectObj.get("RowID");
					var DTYFlag=selectObj.get("DTYFlag");
					var DTYCode=selectObj.get("DTYCode");
					var DTYDesc=selectObj.get("DTYDesc");
					var DTYRemark=selectObj.get("DTYRemark");
					var DelStr=DTYFlag+"^"+DTYCode+"^"+DTYDesc+"^"+DTYRemark+"^"+Id+"^"+"Delete";
					var DelOBJ = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
					var ret = DelOBJ.Update(DelStr);
					if (ret==5){
						ExtTool.alert("��ʾ","ɾ���ɹ�!");
					}else{
						ExtTool.alert("��ʾ","ɾ��ʧ��!");
					}
					obj.clear();
				}		
			}  
		}else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}
	};
	//����
	obj.btnUpdate_click  = function(){
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			Ext.MessageBox.show({
		    	title:'��ʾ',
		    	msg:'��ȷ��Ҫ����ô��',
		    	modal:true,
		    	width:260,
				fn:callBack,
		    	icon:Ext.Msg.INFO,
		    	buttons:Ext.Msg.OKCANCEL	
				//buttons:Ext.Msg.YESNOCANCEL
			});
			function callBack(btn){
				if(btn=="ok"){
					var Id=selectObj.get("RowID");
					var bodyCode=obj.bodyCode.getValue();	//����
					var bodyDesc=obj.bodyDesc.getValue();	//����
					var bodyNote=obj.bodyNote.getValue();	//��ע
					var bodyType=obj.bodyType.getRawValue();	//����
					var UpdateStr=bodyType+"^"+bodyCode+"^"+bodyDesc+"^"+bodyNote+"^"+Id+"^"+"Update";
					alert(UpdateStr);
					var Updateobj = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
					var ret = Updateobj.Update(UpdateStr);
					if (ret==4){
						ExtTool.alert("��ʾ","���³ɹ�!");
					}
					if (ret==3){
						ExtTool.alert("��ʾ","������ȫһ��,���ø���!");
					}
					obj.clear();
				}		
			}  
		}else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}
	};
	
	obj.gridList_rowclick=function()        
	{
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj)
	    {
		    var DTYCode=selectObj.get('DTYCode');
		    var DTYDesc=selectObj.get('DTYDesc');
		    var DTYFlag=selectObj.get('DTYFlag');
		    var DTYRemark=selectObj.get('DTYRemark');
		    var RowID=selectObj.get('RowID');
			var Flagobj = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
			var Flag = Flagobj.CheckSelect(DTYFlag);
			Ext.getDom('bodyCode').value=DTYCode;
			Ext.getDom("bodyDesc").value=DTYDesc;
			Ext.getDom("bodyType").value=Flag;
			Ext.getDom("bodyNote").value=DTYRemark;
	    }
	};
	//����Excel����
	obj.btnInput_click= function()
	{
	var lnk="PMPDictionary.CSP"
	var nwin="scrollbars=yes,top=0,left=0,width=900,height=600"
	window.open(lnk,'_blank',nwin);
	}
	//��ѯ
	obj.btnSch_click = function(){
		obj.gridListStore.removeAll();
		obj.gridListStore.load({params : {start:0,limit:20}});
	};
	//����
    obj.btnClear_click = function(){
		obj.clear();
	};
	//�Ҽ�
	obj.rightClickFn_click = function (gridList,rowIndex,e){ 
		obj.gridList.getSelectionModel().selectRow(rowIndex);
        e.preventDefault(); 
        obj.RightMenu.showAt(e.getXY());    //��ȡ����
    };
	//����
	obj.btnSave1_click= function()
	{
		var objWinAdd = new InitwinScreen();
		objWinAdd.windictionary.show();
	};
	//����
	obj.btnUpdate1_click=function()
	{
		var winselectObj = obj.gridList.getSelectionModel().getSelected();
		if (winselectObj)
		{
				var objWinAdd = new InitwinScreen(winselectObj);
				objWinAdd.windictionary.show();
				var wingridId = winselectObj.get("RowID");
				var wingridbodyType = winselectObj.get("DTYFlag");	        //����
				var wingridbodyCode = winselectObj.get("DTYCode");	        //����
				var wingridbodyDesc = winselectObj.get("DTYDesc");	        //����
				var wingridbodyNote = winselectObj.get("DTYRemark");	    //��ע
					
				objWinAdd.winRowid.setValue(wingridId);
				objWinAdd.winbodyType.setValue(wingridbodyType);
				objWinAdd.winbodyCode.setValue(wingridbodyCode);
				objWinAdd.winbodyDesc.setValue(wingridbodyDesc);
				objWinAdd.winbodyNote.setValue(wingridbodyNote);
		}
		else
		{
			Ext.Msg.show({
	        title : '��ʾ',
			msg : '��ѡ����Ҫ�޸ĵ�����!',
			icon : Ext.Msg.WARNING,
			buttons : Ext.Msg.OK
			  });
		}		
	};
	//˫��
	obj.gridList_rowclick=function(rowIndex,columnIndex,e){
	obj.btnUpdate1_click();
	};
	
	obj.clear = function(){
		Ext.getCmp('bodyCode').setValue("");
		Ext.getCmp('bodyDesc').setValue("");
		Ext.getCmp('bodyNote').setValue("");
		Ext.getCmp('bodyType').setValue("");
		obj.gridListStore.removeAll();
		obj.gridListStore.load({params : {start:0,limit:20}});
	}
}
//�����¼�����
function InitwinScreenEvent(obj)
{
	obj.LoadEvent = function(){};
	var parent=objControlArry['Viewport'];
	
	obj.winSave_click=function()
	{	
		var winbodyOBJ = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
		var winType=obj.winbodyType.getValue();	//����
		if (winType=="") {ExtTool.alert("��ʾ","��ѡ���ֵ����ͣ�");return;}
		var winCode=obj.winbodyCode.getValue();	//����
		if (winCode=="") {ExtTool.alert("��ʾ","����д�ֵ���룡");return;}
		var winDesc=obj.winbodyDesc.getValue();	//����
		if (winDesc=="") {ExtTool.alert("��ʾ","����д�ֵ�������");return;}
		var winNote=obj.winbodyNote.getValue();	//����
		var winStr=winType+"^"+winCode+"^"+winDesc+"^"+winNote;
		try
		{
			if(obj.winRowid.getValue()=="")
			{
				var Id=""
				var winSaveStr=winStr+"^"+Id+"^"+"Insert";
				var ret = winbodyOBJ.Update(winSaveStr);
				if (ret==9){   
						ExtTool.alert("��ʾ","����ɹ�!");
					}else{
						ExtTool.alert("��ʾ","���ʧ��!");
				}
				obj.windictionary.close();
				parent.gridListStore.removeAll();
				parent.gridListStore.load({});
			}
			else 
			{

				var winUpdateStr=winStr+"^"+obj.winRowid.getValue()+"^"+"Update";
				var ret = winbodyOBJ.Update(winUpdateStr);
				if (ret==4){
					ExtTool.alert("��ʾ","���³ɹ�!");
					}
					if (ret==3){
						ExtTool.alert("��ʾ","������ȫһ��,���ø���!");
					}
				obj.windictionary.close();
				parent.gridListStore.removeAll();
				parent.gridListStore.load({});
			}
		}
		catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	}
	obj.winclear = function(){
		Ext.getCmp('winbodyType').setValue("");
		Ext.getCmp('winbodyCode').setValue("");
		Ext.getCmp('winbodyDesc').setValue("");
		Ext.getCmp('winbodyNote').setValue("");
	}
	
	obj.winCancel_click=function()
		{
		obj.windictionary.close();
		};

}