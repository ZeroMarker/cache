/*!
 * 编写日期:2010-04-27
 * 作者：李宇峰
 * 说明：临床路径的维护界面的事件
 * 名称：EditPathWayEvent.js
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
				Desc:"其它"
			});
			var objType2 = new Ext.data.Record({
				Rowid : "-1",
				Desc:"全部"
			});
			obj.PathTypeComStore.insert(0,objType1)
			obj.PathTypeComStore.insert(0,objType2)
		});
	}
	
	obj.AddPathWay=function(){                       //添加一条临床路径
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
				           title: '警告',
				           msg: '此Code已经存在!',
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
				alert("开始日期不能大于结束日期")
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
			//alert("类型不能为空")	
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
				           msg: '添加失败!',
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
					           title: '警告',
					           msg: '此Code已经存在!',
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
				alert("开始日期不能大于结束日期")
				return;	
			}
		}else{
			dateTo=""	
		}
		var pathType=obj.PathTypeCom.getValue();
		if(pathType==""){
			//alert("类型不能为空")	
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
				           msg: '修改失败!',
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
			alert("请选择要删除的记录");
			return;	
		}	
		Ext.MessageBox.confirm('删除', '确定要删除这个临床路径?', function(btn,text){
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
							           msg: '删除失败!',
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

