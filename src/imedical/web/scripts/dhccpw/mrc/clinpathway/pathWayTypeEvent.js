

function pathWayTypeEvent(obj) {
	
	obj.currRowIndex = -1; //Modified By LiYang 2011-05-28 ȥ����Ӱ�ť
	
	obj.LoadEvent = function()
  {};
  obj.PathTypeAdd_click = function(){                 //������ͷ���
  	var code=obj.PathTypeCode.getValue();
  	var desc=obj.PathTypeDesc.getValue();
  	if(code==""){
 		Ext.MessageBox.show({
			title: 'Failed',
			msg: 'Code����Ϊ��!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 �ٴ�·��ά��--�����ֵ�ά��-·������ά��-����ͳһ��ʾ��Ϣ�����ʾ��� 		
  		//alert("Code����Ϊ��")
  		return	
  	}
  	if(desc==""){
 		Ext.MessageBox.show({
			title: 'Failed',
			msg: '�������Ʋ���Ϊ��!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 �ٴ�·��ά��--�����ֵ�ά��-·������ά��-����ͳһ��ʾ��Ϣ�����ʾ��� 		  		
  		//alert("�������Ʋ���Ϊ��")
  		return	
  	}
		var CheckTypeCodeMethod=document.getElementById('CheckTypeCodeMethod');
		if(CheckTypeCodeMethod){
			var encmeth=CheckTypeCodeMethod.value;	
		}else{
			var encmeth=""	
		}
		var checkCodeVal=cspRunServerMethod(encmeth,code,"");
		if(checkCodeVal==1){
	 		Ext.MessageBox.show({
				title: 'Failed',
				msg: 'Code���ظ��ģ����������!',
				buttons: Ext.MessageBox.OK,
				icon:Ext.MessageBox.ERROR
			}); //Modified By LiYang 2011-05-21 FixBug:55 �ٴ�·��ά��--�����ֵ�ά��-·������ά��-����ͳһ��ʾ��Ϣ�����ʾ��� 		  				
			//alert("Code���ظ��ģ����������")
			return;	
		}
		var AddTypeCodeMethod=document.getElementById('AddTypeCodeMethod')
		if(AddTypeCodeMethod){
			var encmeth=AddTypeCodeMethod.value;
		}else{
			var encmeth=""	
		}
		var addVal=cspRunServerMethod(encmeth,code,desc);
		if(addVal>=0){
			obj.PathTypeGridStore.load({});	
			obj.ClearAllValue();
			//Ext.getCmp("way-tree").loadTypes();
		}else{
			Ext.MessageBox.show({
				title: 'Failed',
				msg: '���ʧ��!',
				buttons: Ext.MessageBox.OK,
				icon:Ext.MessageBox.ERROR
			});
		}
	
	};
	obj.updateType=function(){
		var code=obj.PathTypeCode.getValue();
  	var desc=obj.PathTypeDesc.getValue();
  	if(code==""){
	 	Ext.MessageBox.show({
			title: 'Failed',
			msg: 'Code����Ϊ��!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 �ٴ�·��ά��--�����ֵ�ά��-·������ά��-����ͳһ��ʾ��Ϣ�����ʾ��� 		  		
		//alert("Code����Ϊ��")
  		return	
  	}
  	if(desc==""){
 	 	Ext.MessageBox.show({
			title: 'Failed',
			msg: '�������Ʋ���Ϊ��!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 �ٴ�·��ά��--�����ֵ�ά��-·������ά��-����ͳһ��ʾ��Ϣ�����ʾ��� 		  		
  		//alert("�������Ʋ���Ϊ��")
  		return	
  	}
		var CheckTypeCodeMethod=document.getElementById('CheckTypeCodeMethod');
		if(CheckTypeCodeMethod){
			var encmeth=CheckTypeCodeMethod.value;	
		}else{
			var encmeth=""	
		}
		var checkCodeVal=cspRunServerMethod(encmeth,code,obj.typeRowid1);
		if(checkCodeVal==1){
 	 	Ext.MessageBox.show({
			title: 'Failed',
			msg: 'Code���ظ��ģ����������!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 �ٴ�·��ά��--�����ֵ�ά��-·������ά��-����ͳһ��ʾ��Ϣ�����ʾ��� 		  		
//			alert("Code���ظ��ģ����������")
			return;	
		}
		if(obj.typeRowid1==""){
			return;	
		}
		var UpdateTypeMethod=document.getElementById('UpdateTypeMethod')
		if(UpdateTypeMethod){
			var encmeth=UpdateTypeMethod.value;	
		}else{
			var encmeth=""	
		}
		var updateVal=cspRunServerMethod(encmeth,obj.typeRowid1,code,desc);
		if(updateVal>=0){
				obj.PathTypeGridStore.load({});	
				//var pathPanel=Ext.getCmp("way-tree")
				//var typeNode=pathPanel.getNodeById(obj.typeRowid1+"_type")
				//typeNode.setText(desc)
				obj.ClearAllValue();
				//Add By Niucaicai 2011-07-19 FixBug:92 �ٴ�·��ά��-������Ϣά��-·������ά��-ɾ��һ����¼���ܱ����µļ�¼
				obj.currRowIndex = -1;
		}else{
			Ext.MessageBox.show({
				title: 'Failed',
				msg: '�޸�ʧ��!',
				buttons: Ext.MessageBox.OK,
				icon:Ext.MessageBox.ERROR
			});
		}
	};
	obj.rowSelect=function(sm, rowIdx, r){
		//��ѡ��grid�еĸ�һ��ʱ���������¼�
		if(obj.currRowIndex != rowIdx)
		{
			var record=obj.PathTypeGrid.getSelectionModel().getSelected();    //�����ѡ�е�һ�е�Record����
			obj.typeRowid1=record.get("typeRowid");
			obj.PathTypeCode.setValue(record.get("typeCode"));
			obj.PathTypeDesc.setValue(record.get("typeDesc"));		
			if (record.get("typeCode")=="SYNDROME"){    //add by wuqk 2011-07-21 ����֢���Ͳ����޸�
				obj.PathTypeCode.setDisabled(true);
				obj.PathTypeDesc.setDisabled(true);
			}
			else{
				obj.PathTypeCode.setDisabled(false);
				obj.PathTypeDesc.setDisabled(false);
			}
			obj.currRowIndex = rowIdx;
		}
		else
		{
			obj.PathTypeCode.setDisabled(false);
			obj.PathTypeDesc.setDisabled(false);
			obj.typeRowid1="";
			obj.PathTypeCode.setValue("");
			obj.PathTypeDesc.setValue("");				
			obj.currRowIndex = -1;
		}

	};
	obj.deleteType=function(){
		if(obj.typeRowid1==""){
	 	 	Ext.MessageBox.show({
				title: 'Failed',
				msg: '��ѡ��һ��!',
				buttons: Ext.MessageBox.OK,
				icon:Ext.MessageBox.ERROR
			}); //Modified By LiYang 2011-05-21 FixBug:55 �ٴ�·��ά��--�����ֵ�ά��-·������ά��-����ͳһ��ʾ��Ϣ�����ʾ��� 		  		
			//alert("��ѡ��һ��")
			return;	
		}	
		Ext.MessageBox.confirm('ɾ��', 'ȷ��ɾ������ٴ�·��������', function(btn,text){
    			if(btn=="yes"){
						var DeleteTypeMethod=document.getElementById('DeleteTypeMethod')
						if(DeleteTypeMethod){
							var encmeth=DeleteTypeMethod.value;	
						}else{
							var encmeth=""
						}
						var deleteVal=cspRunServerMethod(encmeth,obj.typeRowid1);
						if(deleteVal>=0){
							obj.PathTypeGridStore.load({});
							//var pathPanel=Ext.getCmp("way-tree")
							//var typeNode=pathPanel.getNodeById(obj.typeRowid1+"_type")
							//typeNode.remove();
							obj.ClearAllValue();
							//Add By Niucaicai 2011-07-19 FixBug:92 �ٴ�·��ά��-������Ϣά��-·������ά��-ɾ��һ����¼���ܱ����µļ�¼
							obj.currRowIndex = -1;
						}else{
							Ext.MessageBox.show({
					           title: 'Failed',
					           msg: 'ɾ��ʧ��!',
					           buttons: Ext.MessageBox.OK,
					           icon:Ext.MessageBox.ERROR
					   		});	
						}
           }
    });
		
		
	}
	obj.ClearAllValue=function(){
		obj.typeRowid1="";
		obj.PathTypeCode.reset();	
		obj.PathTypeDesc.reset();
		obj.PathTypeGrid.getSelectionModel().clearSelections()
		
	}
	
	obj.btnSaveOnclick = function()
	{
		if(obj.currRowIndex == -1)
		{
			obj.PathTypeAdd_click();
		}
		else
		{
			obj.updateType();
		}
			
	}
}