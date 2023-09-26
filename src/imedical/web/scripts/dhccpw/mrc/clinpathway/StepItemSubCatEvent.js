
function StepItemSubCatEvent(obj) {
	obj.currRowIndex = -1;  //��¼��ǰ���Index Modified By LiYang 2011-05-25
	obj.LoadEvent = function()
  {
  	//var n1=obj.StepItemSubCatGrid.getSelectionModel().getCount() //selectRow(0)
  	//alert(n1)
  };
  obj.AddItemSub=function(){    //���һ����Ŀ�����¼
  	if(!obj.ItemSubCatCom.validate()) return
  	var ItemRowid=obj.ItemSubCatCom.getValue();
  	if(!obj.ItemSubCatCode.validate()) return
  	var code=obj.ItemSubCatCode.getValue();
  	
  	//���code�Ƿ�Ψһ
  	var checkVal=obj.CheckItemSubCode(code,"")
  	if(checkVal==1){
		  Ext.MessageBox.show({
		     title: '��ʾ',
		     msg: '�����Ѿ����ڣ�����������!',
		     buttons: Ext.MessageBox.OK,
		    	icon:Ext.MessageBox.ERROR
		});  		//ͳһ��ʾ��� Modified By LiYang 2011-05-25  		  		
  		//alert("�����Ѿ����ڣ�����������")
  		obj.ItemSubCatCode.setValue("");
  		return
  	}
  	if(!obj.ItemSubCatDesc.validate()) return
  	var desc=obj.ItemSubCatDesc.getValue();
  	if(!obj.ItemSubCatDateFrom.validate()) return;
  	var dateFrom=obj.ItemSubCatDateFrom.getValue();
  	if(dateFrom!=""){
  		dateFrom=dateFrom.format("Y-m-d");
  	}else{
  		dateFrom=""	
  		return;
  	}
  	if(!obj.ItemSubCatDateTo.validate()) return;
  	var dateTo=obj.ItemSubCatDateTo.getValue();
  	if(dateTo!=""){
  		dateTo=dateTo.format("Y-m-d");	
  		if(dateTo<dateFrom){
		  	Ext.MessageBox.show({
		          title: '��ʾ',
		          msg: '��ʼ���ڲ��ܴ��ڽ�������!',
		       	buttons: Ext.MessageBox.OK,
		    		icon:Ext.MessageBox.ERROR
			});  		//ͳһ��ʾ��� Modified By LiYang 2011-05-25  		  			
  			//alert("��ʼ���ڲ��ܴ��ڽ�������")
  			return;	
  		}
  	}else{
  		dateTo=""	
  	}
  	
  	var ItemSubCatPower=obj.cboItemSubCatPower.getValue();
  	
  	var AddItemSubCatMethod=document.getElementById('AddItemSubCatMethod')
  	if(AddItemSubCatMethod){
  		var encmeth=AddItemSubCatMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  	var addVal=cspRunServerMethod(encmeth,ItemRowid,code,desc,dateFrom,dateTo,ItemSubCatPower)
  	if(addVal<0){
		Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '���ʧ��!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
		});
  	}else{
  		obj.ClearItemSubCat();
			obj.StepItemSubCatStore.load({
			params:{Arg1:"",Arg2:"",Arg3:"",Arg4:"",Arg5:"",ArgCnt:5,start:0,limit:10}
		});
  	}
  }
  obj.CheckItemSubCode=function(Code,ItemSubRowid){   //���code�Ƿ��Ѿ�����
  		var CheckItemSubCodeMethod=document.getElementById('CheckItemSubCodeMethod')
  		if(CheckItemSubCodeMethod){
  			var encmeth=CheckItemSubCodeMethod.value;	
  		}else{
  			var encmeth=""	
  		}
  		var checkValue=cspRunServerMethod(encmeth,Code,ItemSubRowid)
  		return checkValue
  }
  obj.ClearItemSubCat=function(){         //�����������ֵ
  		obj.ItemSubCatCode.reset()
  		obj.ItemSubCatDesc.reset()
  		obj.ItemSubCatDateFrom.reset()
  		obj.ItemSubCatDateTo.reset()
  		obj.ItemSubCatRowid=""
  		obj.ItemSubCatCom.reset()
  		obj.cboItemSubCatPower.reset()
  		obj.StepItemSubCatGrid.getSelectionModel().clearSelections();
		obj.currRowIndex = -1;	//	Add by zhaoyu 2012-11-26 �ٴ�·��ά��-��Ŀ����-ɾ����Ϣ����������ݣ���ʾ"��ѡ��һ����¼" 195
  }
  obj.ItemSubCatSelect=function(objGrid, rowIndex){
  	if(obj.currRowIndex != rowIndex )
  	{
	  	var record=obj.StepItemSubCatGrid.getSelectionModel().getSelected();	
	  	obj.ItemSubCatRowid=record.get('Rowid')
	  	obj.ItemSubCatCom.setValue(record.get('ItemRowid'));
	  	obj.ItemSubCatCode.setValue(record.get('Code'));
	  	obj.ItemSubCatDesc.setValue(record.get('Desc'));
	  	obj.ItemSubCatDateFrom.setValue(record.get('DateFrom'));
	  	obj.ItemSubCatDateTo.setValue(record.get('DateTo'));
	  	obj.cboItemSubCatPower.setValue(record.get('SubCatPower'));
	  	obj.cboItemSubCatPower.setRawValue(record.get('SubCatPowerDesc'));
	  	obj.currRowIndex = rowIndex;
	  }
	  else
	  {
	  	obj.ItemSubCatRowid="";
	  	obj.ItemSubCatCom.setValue("");
	  	obj.ItemSubCatCode.setValue("");
	  	obj.ItemSubCatDesc.setValue("");
	  	obj.ItemSubCatDateFrom.setValue("");
	  	obj.ItemSubCatDateTo.setValue("");
	  	obj.cboItemSubCatPower.setValue("");
	  	obj.cboItemSubCatPower.setRawValue("");	  	
	  	obj.currRowIndex = -1;
	  }
  }
  obj.UpdateItemSub=function(){     //�޸�һ����¼��
  	if(obj.ItemSubCatRowid==""){
	  	Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '��ѡ��һ����¼!',
	       	buttons: Ext.MessageBox.OK,
	    		icon:Ext.MessageBox.ERROR
		});  		//ͳһ��ʾ��� Modified By LiYang 2011-05-25  		  		
  		//alert("��ѡ��һ����¼")
  		return;	
  	}
  	if(!obj.ItemSubCatCom.validate()) return
  	var ItemRowid=obj.ItemSubCatCom.getValue();
  	if(!obj.ItemSubCatCode.validate()) return
  	var code=obj.ItemSubCatCode.getValue();
  	
  	//���code�Ƿ�Ψһ
  	var checkVal=obj.CheckItemSubCode(code,obj.ItemSubCatRowid)
  	if(checkVal==1){
	  	Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '�����Ѿ����ڣ�����������!',
	       	buttons: Ext.MessageBox.OK,
	    		icon:Ext.MessageBox.ERROR
		});  		//ͳһ��ʾ��� Modified By LiYang 2011-05-25  			  		
  		//alert("�����Ѿ����ڣ�����������")
  		obj.ItemSubCatCode.setValue("");
  		return
  	}
  	if(!obj.ItemSubCatDesc.validate()) return
  	var desc=obj.ItemSubCatDesc.getValue();
  	if(!obj.ItemSubCatDateFrom.validate()) return;
  	var dateFrom=obj.ItemSubCatDateFrom.getValue();
  	if(dateFrom!=""){
  		dateFrom=dateFrom.format("Y-m-d");
  	}else{
  		dateFrom=""	
  		return;
  	}
  	if(!obj.ItemSubCatDateTo.validate()) return;
  	var dateTo=obj.ItemSubCatDateTo.getValue();
  	if(dateTo!=""){
  		dateTo=dateTo.format("Y-m-d");	
  		if(dateTo<dateFrom){
	  		Ext.MessageBox.show({
	           title: '��ʾ',
	           msg: '��ʼ���ڲ��ܴ��ڽ�������!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.ERROR
			});  		//ͳһ��ʾ��� Modified By LiYang 2011-05-25  			
  			//alert("��ʼ���ڲ��ܴ��ڽ�������")
  			return;	
  		}
  	}else{
  		dateTo=""	
  	}
  	
  	var ItemSubCatPower=obj.cboItemSubCatPower.getValue();
  	
		var UpdateItemSubCatMethod=document.getElementById('UpdateItemSubCatMethod');
		if(UpdateItemSubCatMethod){
			var encmeth=UpdateItemSubCatMethod.value;	
		}else{
			var encmeth=""	
		}
		var updateVal=cspRunServerMethod(encmeth,obj.ItemSubCatRowid,code,desc,dateFrom,dateTo,ItemSubCatPower)
		if(updateVal<0){
			Ext.MessageBox.show({
				           title: '����',
				           msg: '�޸�ʧ��!',
				           buttons: Ext.MessageBox.OK,
				           icon:Ext.MessageBox.WARNING
			});	
		}else{
			obj.ClearItemSubCat();
			obj.StepItemSubCatStore.load({
				params:{Arg1:"",Arg2:"",Arg3:"",Arg4:"",Arg5:"",ArgCnt:5,start:0,limit:10}
			});	
		}
  }
  obj.DeleteItemSu=function(){
  	if(obj.ItemSubCatRowid==""){
  		Ext.MessageBox.show({
           title: 'Failed',
           msg: '��ѡ��һ����¼!',
           buttons: Ext.MessageBox.OK,
           icon:Ext.MessageBox.ERROR
		});  		//ͳһ��ʾ��� Modified By LiYang 2011-05-25
  		return;	
  	}
  	Ext.Msg.show({
	   title:'ɾ��ȷ��?',
	   msg: '��ȷ��Ҫɾ�������Ŀ������?',
	   buttons: Ext.Msg.YESNO,
	   fn: function(btn)
		   {
		   		if(btn != 'yes')
		   			return;
				var DeleteItemSubCatMethod=document.getElementById('DeleteItemSubCatMethod')
				  	if(DeleteItemSubCatMethod){
				  		var encmeth=DeleteItemSubCatMethod.value;	
				  	}else{
				  		var encmeth=""	
				  	}
				  	var deleteVal=cspRunServerMethod(encmeth,obj.ItemSubCatRowid)
				  	if(deleteVal<0){
				  		Ext.MessageBox.show({
				           title: 'Failed',
				           msg: 'ɾ��ʧ��!',
				           buttons: Ext.MessageBox.OK,
				           icon:Ext.MessageBox.ERROR
						});
				  	}else{
						obj.ClearItemSubCat();
						obj.StepItemSubCatStore.load({
							params:{Arg1:"",Arg2:"",Arg3:"",Arg4:"",Arg5:"",ArgCnt:5,start:0,limit:10}
						});	
				  	}		   		
		   	}
	   ,icon: Ext.MessageBox.QUESTION
	});
  }
  
  obj.btnSaveOnclick = function()
  {
  	if(obj.currRowIndex == -1)
  		obj.AddItemSub();
  	else
  		obj.UpdateItemSub();
  }
}

