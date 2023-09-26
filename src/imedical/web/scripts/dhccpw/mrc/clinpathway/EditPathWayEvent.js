/*!
 * ��д����:2010-04-27
 * ���ߣ������
 * ˵�����ٴ�·����ά��������¼�
 * ���ƣ�EditPathWayEvent.js
 */
function EditPathWayEvent(obj,way) {
	obj.LoadEvent = function()
	{
		obj.PathAdd.on('click',obj.AddPathWay);
		obj.PathUpdate.on('click',obj.UpdatePathWay);
		obj.PathWayGrid.getSelectionModel().on('rowselect',obj.PathWaySelect);
		obj.PathDelete.on('click',obj.DeletePathWay);
		obj.ClearBtn.on('click',obj.ClearAllValue);
		obj.btnQuery.on('click',obj.btnQuery_onclick);
		obj.PathTypeComStore.on('load',function(){
			var objType1 = new Ext.data.Record({
				Rowid : "0",
				Desc:"����"
			});
			var objType2 = new Ext.data.Record({
				Rowid : "-1",
				Desc:"ȫ��"
			});
			obj.PathTypeComStore.insert(0,objType1)
			obj.PathTypeComStore.insert(0,objType2)
		});
	}
	
	obj.AddPathWay=function(){                       //���һ���ٴ�·��
		if(!obj.PathCode.validate()){return}
		if(!obj.PathDesc.validate()) { return}
		if(!obj.PathDateFrom.validate()) {return}
		if(!obj.PathDateTo.validate()) {return}
		var code=obj.PathCode.getValue();
		var cost=obj.PathCost.getValue();
		var CPWDays=obj.PathDays.getValue();
		var CPWICD=obj.PathICD.getValue();
		var CPWLabel=obj.PathLabel.getValue();
		var CheckPathCodeMethod=document.getElementById('CheckPathCodeMethod');
		if(CheckPathCodeMethod){
			var encmeth=CheckPathCodeMethod.value;	
		}else{
			var encmeth=""	
		}
		var checkCodeVal=cspRunServerMethod(encmeth,code,"");
		if(checkCodeVal==1){
				Ext.MessageBox.show({
				           title: '����',
				           msg: '��Code�Ѿ�����!',
				           buttons: Ext.MessageBox.OK,
				           icon:Ext.MessageBox.WARNING
				       });
					return;
				}
		var desc=obj.PathDesc.getValue();
		var active=	obj.PathActive.getValue();
		var dateFrom=obj.PathDateFrom.getValue();
		if(dateFrom!=""){
			dateFrom=dateFrom.format("Y-m-d");
		}else{
			dateFrom=""	
			return;
		}
		var dateTo=obj.PathDateTo.getValue();
		if(dateTo!=""){
			dateTo=dateTo.format("Y-m-d");	
			if(dateTo<dateFrom){
				alert("��ʼ���ڲ��ܴ��ڽ�������")
				return;	
			}
		}else{
			dateTo=""	
		}
	
		var pathType=obj.PathTypeCom.getValue();
		if((pathType==-1) || (pathType==0)) {
			
			pathType=""; 
		}
		if(pathType==""){
			//alert("���Ͳ���Ϊ��")	
			//return;
		}
		var AddPathMethod=document.getElementById('AddPathMethod')
		if(AddPathMethod){
			var encmeth=AddPathMethod.value;
		}else{
			var encmeth=""	
		}
		var addVal=cspRunServerMethod(encmeth,code,desc,active,dateFrom,dateTo,pathType,cost,CPWDays,CPWICD,CPWLabel)
		if(addVal==0){
			obj.ClearAllValue();
			var pathPanel=Ext.getCmp("way-tree");
			if(pathType=="") pathType="Other"
			pathPanel.loadPathWays(pathPanel.getNodeById(pathType+"_type"))
		}else{
			Ext.MessageBox.show({
				           title: 'Failed',
				           msg: '���ʧ��!',
				           buttons: Ext.MessageBox.OK,
				           icon:Ext.MessageBox.WARNING
				       });	
		}
	}
	obj.UpdatePathWay=function(){
		if(!obj.PathCode.validate()){return}
		if(!obj.PathDesc.validate()) { return}
		if(!obj.PathDateFrom.validate()) {return}
		if(!obj.PathDateTo.validate()) {return}
		var code=obj.PathCode.getValue();
		var cost=obj.PathCost.getValue();
		var CPWDays=obj.PathDays.getValue();
		var CPWICD=obj.PathICD.getValue();
		var CPWLabel=obj.PathLabel.getValue();
		var CheckPathCodeMethod=document.getElementById('CheckPathCodeMethod');
		if(CheckPathCodeMethod){
			var encmeth=CheckPathCodeMethod.value;	
		}else{
			var encmeth=""	
		}
		var checkCodeVal=cspRunServerMethod(encmeth,code,obj.pathWayRowid);
			if(checkCodeVal==1){
					Ext.MessageBox.show({
					           title: '����',
					           msg: '��Code�Ѿ�����!',
					           buttons: Ext.MessageBox.OK,
					           icon:Ext.MessageBox.WARNING
					       });
						return;
					}
		var desc=obj.PathDesc.getValue();
		var active=	obj.PathActive.getValue();
		var dateFrom=obj.PathDateFrom.getValue();
		if(dateFrom!=""){
			dateFrom=dateFrom.format("Y-m-d");
		}else{
			dateFrom=""	
		}
		var dateTo=obj.PathDateTo.getValue();
		if(dateTo!=""){
			dateTo=dateTo.format("Y-m-d");	
			if(dateTo<dateFrom){
				alert("��ʼ���ڲ��ܴ��ڽ�������")
				return;	
			}
		}else{
			dateTo=""	
		}
		var pathType=obj.PathTypeCom.getValue();
		if(pathType==""){
			//alert("���Ͳ���Ϊ��")	
			//return;
		}
		var UpdatePathMethod=document.getElementById('UpdatePathMethod')
		if(UpdatePathMethod){
			var encmeth=UpdatePathMethod.value;	
		}else{
			var encmeth=""
		}
		
		var updateVal=cspRunServerMethod(encmeth,obj.pathWayRowid,code,desc,active,dateFrom,dateTo,pathType,cost,CPWDays,CPWICD,CPWLabel)
		if(updateVal==0){
			obj.PathWayStore.load({});
			var pathPanel=Ext.getCmp("way-tree");
			var pathNode=pathPanel.getNodeById(obj.pathWayRowid+"_path")
			if(pathNode){
				pathNode.setText(desc)
			}	
			if(obj.updateType!=pathType){
				var id=obj.pathWayRowid+"_path"
				var pathNode=pathPanel.getNodeById(id)
				if(pathNode){
					pathNode.remove()
				}
			}
			pathPanel.loadPathWays(pathPanel.getNodeById(pathType+"_type"))
			obj.ClearAllValue();
		}else{
			Ext.MessageBox.show({
				           title: 'Failed',
				           msg: '�޸�ʧ��!',
				           buttons: Ext.MessageBox.OK,
				           icon:Ext.MessageBox.WARNING
				       });	
		}
	}
	obj.PathWaySelect=function(sm, rowIdx, r){
		var record=obj.PathWayGrid.getSelectionModel().getSelected();
		obj.pathWayRowid=record.get("Rowid");
		obj.PathCode.setValue(record.get("code"))
		obj.PathDesc.setValue(record.get("desc"));
		obj.PathActive.setValue(record.get("active"));
		obj.PathDateFrom.setValue(record.get("dateFrom"));
		obj.PathDateTo.setValue(record.get("dateTo"));
		obj.PathTypeCom.setValue(record.get("type"));
		obj.updateType=record.get("type");
		obj.PathTypeCom.setRawValue(record.get("typeDesc"));
		obj.PathCost.setValue(record.get('cost'))
		obj.PathDays.setValue(record.get('CPWDays'))
		obj.PathICD.setValue(record.get('CPWICD'))
		obj.PathLabel.setValue(record.get('CPWLabel'))
	}
	obj.DeletePathWay=function(){
		if(obj.pathWayRowid==""){
			alert("��ѡ��Ҫɾ���ļ�¼");
			return;	
		}	
		Ext.MessageBox.confirm('ɾ��', 'ȷ��Ҫɾ������ٴ�·��?', function(btn,text){
					if(btn=="yes"){
		      	var delVal=obj.CliPathWayService.DeletePathWay(obj.pathWayRowid)
					  	if(delVal==0){
								//obj.PathWayStore.load({});
								var record=obj.PathWayGrid.getSelectionModel().getSelected();
								obj.PathWayStore.remove(record)
								var pathPanel=Ext.getCmp("way-tree");
								var node=pathPanel.getNodeById(obj.pathWayRowid+"_path")
								if(node){
									node.remove();
								}
								obj.ClearAllValue();
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
		obj.updateType=""
		obj.pathWayRowid=""
		obj.PathDesc.reset();
		obj.PathActive.reset();
		obj.PathDateFrom.reset();
		obj.PathCode.reset();
		obj.PathDateTo.reset();
		//obj.PathTypeCom.reset();
		obj.PathCost.reset();
		obj.PathDays.reset();
		obj.PathICD.reset();
		obj.PathLabel.reset();
		obj.PathWayGrid.getSelectionModel().clearSelections();
	}
	obj.btnQuery_onclick=function(){
		obj.PathWayStore.load({});
	}
}

