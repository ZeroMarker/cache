

function PathWEpStepEvent(obj) {
  var StepService = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStep");
  obj.LoadEvent = function(){};
  obj.AddStep=function(){
  	var day=obj.StepDay.getValue();
  	if(day==""){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: 'ʱ�䲻��Ϊ��!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26    		
  		//alert("ʱ�䲻��Ϊ��")
  		return
  	}
  	var dayUnit=obj.cboStepDayUnit.getValue();
  	if(dayUnit==""){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: 'ʱ�䵥λ����Ϊ��!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26     		
  		//alert("ʱ�䵥λ����Ϊ��")
  		return
  	}
  	var desc=obj.StepDesc.getValue();
	if(desc==""){	//	Modified by zhaoyu 2012-11-16 �ٴ�·��ά��--·����ά��-��Ӳ��裬������������Ϊ��ʱ����ʾ����ȷ ȱ�ݱ��189
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '������������Ϊ��!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ���     		
  		//alert("������������Ϊ��")
  		return
  	}
  	var dayNum=obj.StepDayNum.getValue();
  	if(dayNum==""){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '������Ų���Ϊ��!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26      		
  		//alert("������Ų���Ϊ��")
  		return	
  	}
  	//�������Ƿ��ظ� 
  	var checkVal=StepService.CheckSameDayNum(dayNum,obj.EpRowid,"")
  	if(checkVal==1){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '������ظ�������������!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26    		
  		//alert("������ظ�������������")
  		return	
  	}
  	//�������Ƿ��ظ�
  	var AddStepMethod=document.getElementById('AddStepMethod')
  	if(AddStepMethod){
  		var encmeth=AddStepMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  	var StepTypeCode=obj.cboStepType.getValue();    //add by wuqk 2011-07-25
  	var addVal=cspRunServerMethod(encmeth,obj.EpRowid,day,desc,dayNum,dayUnit,StepTypeCode);
  	if(addVal<0){
  		Ext.MessageBox.show({
           title: 'Failed',
           msg: '���ʧ��!',
           buttons: Ext.MessageBox.OK,
           icon:Ext.MessageBox.WARNING
		});
  	}else{
		obj.PathWEpStepGridStore.load({});	
		//Modified By LiYang 2010-12-25 ��ʱ��ֹˢ������������οؼ�
		//var stepRowid=Val[1]
		//var mainPanel=Ext.getCmp('main-tree');
		//var epNode=mainPanel.getNodeById(obj.EpRowid);
		//var treeLoader=mainPanel.getLoader() 
		//treeLoader.load(epNode);                     //���¼����¼��صĽ��ĸ���㡣
		obj.ClearStep();
		window.parent.RefreshContentTree();    //by wuqk  2011-07-27  ˢ��·��������
  	}
  }
  obj.ClearStep=function(){          //�����������ֵ
  	obj.StepRowid=""
  	obj.StepDay.setValue();
  	obj.cboStepDayUnit.setValue();
  	obj.StepDesc.setValue();
	obj.cboStepType.setValue();	//Add by zhaoyu 2012-11-27 ·����ά��--·������ά��--�������������Ч 217
  	obj.StepDayNum.setValue();
  	obj.setStepDayNum();
  	obj.PathWEpStepGrid.getSelectionModel().clearSelections();    //ȡ��ѡ��
  }
  obj.setStepDayNum=function(){
  	var GetNewDayNumMethod=document.getElementById('GetNewDayNumMethod')
  	if(GetNewDayNumMethod){
  		var encmeth=GetNewDayNumMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  	var stepDayNum=cspRunServerMethod(encmeth,obj.EpRowid)
  	obj.StepDayNum.setValue(stepDayNum)
  }
  obj.PathWEpStepSelect=function(){
  	//getSelectionModel().getSelected();
  	var record=obj.PathWEpStepGrid.getSelectionModel().getSelected();
  	obj.StepRowid=record.get('StepRowid');
  	obj.StepDay.setValue(record.get('StepDay'));
  	if (record.get('StepDayUnit')==""){           // add by wuqk 2011-07-25 Ĭ��ʱ�䵥λΪ��
  		obj.cboStepDayUnit.setValue('D');
  	}
  	else{
  		obj.cboStepDayUnit.setValue(record.get('StepDayUnit'));
  	}
  	obj.cboStepType.setValue(record.get('StepTypeCode'));
  	
  	//obj.cboStepDayUnit.setValue(record.get('StepDayUnit'));
  	//obj.cboStepDayUnit.setRawValue(record.get('StepDayUnitDesc'));
  	obj.StepDesc.setValue(record.get('StepDesc'))
  	obj.StepDayNum.setValue(record.get('StepDayNum'))
  }
  obj.UpdateStep=function(){
  	if(obj.StepRowid==""){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '��ѡ��һ����¼!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26    	  		
  		//alert("��ѡ��һ����¼")	
  	}
  	var day=obj.StepDay.getValue();
  	if(day==""){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '����ʱ�䲻��Ϊ��!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26    		
  		//alert("����ʱ�䲻��Ϊ��")
  		return	
  	}
  	var dayUnit=obj.cboStepDayUnit.getValue();
  	if(dayUnit==""){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '����ʱ�䵥λ����Ϊ��!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26  	  		
  		//alert("����ʱ�䵥λ����Ϊ��")
  		return	
  	}
  	var desc=obj.StepDesc.getValue();
	if(desc==""){	//	Modified by zhaoyu 2012-11-16 �ٴ�·��ά��--·����ά��-��Ӳ��裬������������Ϊ��ʱ����ʾ����ȷ ȱ�ݱ��189
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '������������Ϊ��!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ���     		
  		//alert("������������Ϊ��")
  		return
  	}
  	var dayNum=obj.StepDayNum.getValue();
  	if(dayNum==""){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '������Ų���Ϊ��!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26  	  		
  		//alert("������Ų���Ϊ��")
  		return	
  	}
  	/*
  	var checkVal=StepService.CheckSameDayNum(dayNum,obj.EpRowid,obj.StepRowid)
  	if(checkVal==1){
  		alert("������ظ�������������")
  		return	
  	}
  	*/
  	var UpdateStepMethod=document.getElementById('UpdateStepMethod')
  	if(UpdateStepMethod){
  		var encmeth=UpdateStepMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  		var StepTypeCode=obj.cboStepType.getValue();    //add by wuqk 2011-07-25
  		var updateVal=cspRunServerMethod(encmeth,obj.StepRowid,day,desc,dayNum,dayUnit,StepTypeCode)
  		if(updateVal<0){
  			Ext.MessageBox.show({
				   title: 'Failed',
				   msg: '�޸�ʧ��!',
				   buttons: Ext.MessageBox.OK,
				   icon:Ext.MessageBox.WARNING
			});	
  		}else{
			obj.PathWEpStepGridStore.load({});	
			obj.ClearStep();
			/*  bug  // by wuqk 2011-07-21
			var mainPanel=Ext.getCmp('main-tree');                 //main-tree -> objContentTree by wuqk 
			var updateNode=mainPanel.getNodeById(obj.StepRowid1)    //pathWayEpRowid-> StepRowid1 by wuqk 
			if(updateNode){
				updateNode.setText(desc+" "+dayNum+" "+day+"ds")
			}*/
		  window.parent.RefreshContentTree();    //by wuqk  2011-07-27  ˢ��·��������
  		}
  }
  obj.DeleteStep=function(){
  	if(obj.StepRowid==""){
  	  Ext.MessageBox.show({
	          title: '��ʾ',
	          msg: '��ѡ��һ����¼!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //ͳһ��ʾ��� Modified By Liyang 2011-05-26  		
  		//alert("��ѡ��һ����¼")
		return	//	Modified by zhaoyu 2012-11-27 ·����ά��--·������ά��--û��ѡ���κ�һ������ɾ������ʾ��Ϣ���� 190	
  	}
  	//Update By NiuCaicai 2011-07-21 FixBug:121 �ٴ�·��ά��--������Ϣά��-·����ά��-ɾ������Ŀʱ��ʾ��Ϣ����
  	Ext.MessageBox.confirm('ɾ��', 'ȷ��ɾ���������?', function(btn,text){
    //Ext.MessageBox.confirm('ɾ��', 'ȷ��ɾ������׶�?', function(btn,text){
			if(btn=="yes"){
		  	var DeleteStepMethod=document.getElementById('DeleteStepMethod');
		  	if(DeleteStepMethod){
		  		var encmeth=DeleteStepMethod.value;	
		  	}else{
		  		var encmeth=""	
		  	}
		  	var deleteVal=cspRunServerMethod(encmeth,obj.StepRowid)
		  	if(deleteVal<0){
		  		Ext.MessageBox.show({
		           title: 'Failed',
		           msg: 'ɾ��ʧ��!',
		           buttons: Ext.MessageBox.OK,
		           icon:Ext.MessageBox.ERROR
				});
		  	}else{
				obj.PathWEpStepGridStore.load({});	
				/*  bug  // by wuqk 2011-07-21
				var mainPanel=Ext.getCmp('main-tree');
				var node=mainPanel.getNodeById(obj.StepRowid)
				if(node){
						node.remove();
				}*/
				obj.ClearStep();
		  	window.parent.RefreshContentTree();    //by wuqk  2011-07-27  ˢ��·��������
		  	}
		  }
		});
  }
  obj.DayKepress=function(textfield,e){    //����"����������"ֻ���������֡�
 
		var allowed = '0123456789';
		var k = e.getKey();
		if (!Ext.isIE && (e.isSpecialKey() || k == e.BACKSPACE || k == e.DELETE)) {
			return;
		}
		var c = e.getCharCode();
		if (allowed.indexOf(String.fromCharCode(c)) === -1) {
			e.stopEvent();
		}

	}
}

