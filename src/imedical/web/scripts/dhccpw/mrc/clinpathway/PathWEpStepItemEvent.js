

function PathWEpStepItemEvent(obj) {
	obj.LoadEvent = function()
	{
		//
	};
  obj.AddPathItem=function(allValue,rowIndex){
  	var desc=allValue['Desc']
  	var groupNo=allValue["GroupNo"];
	//*******	Modified by zhaoyu 2012-11-22 临床路径维护-路径表单维护-维护项目时，【项目分组】输入非数字的字符,保存后都变为0 173
		if ((Number(groupNo).toString()=="NaN")||(Number(groupNo)<=0)||(groupNo.indexOf(".")>0)){
			alert("项目分组错误，请输入正整数！");
			return false;
		};
		//*******
  	var subCat=allValue["SubCatRowid"];
  	var ordSet="";
  	//var ordSet=allValue["OrdSetRowid"];
  	var checkPoint="";  //allValue["CheckPoint"];
  	var checkDesc="";   //allValue["CheckDesc"];
  	var isMust=allValue["IsMustItem"];
  	var pathARCIM=obj.PathARCIM
  	try{
			var stepItemServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItem");
			var ret = stepItemServer.AddStepItem(obj.StepRowid,desc,groupNo,subCat,ordSet,checkPoint,checkDesc,isMust);
			if(ret<0) {
				ExtTool.alert("提示","更新失败!");
				return false;
			}else{
				//obj.PathWEpStepItemStore.load({});
				//var newRowid=stepItemServer.GetNewItem(obj.StepRowid)
				var newRowid=ret; //Modified By LiYang 2011-03-05
				
				//Modified by wuqk 2012-03-14 gui文件中store名称变化
				//obj.PathWEpStepItemStore.getAt(rowIndex).set('StepItemRowid',newRowid)
				//obj.PathWEpStepItemStore.getAt(rowIndex).commit(); //Add By LiYang 2011-03-05提交数据，这样可以去掉每个单元格的红色三角
				obj.CPWEpStepItemGridStore.getAt(rowIndex).set('StepItemRowid',newRowid)

				//	Modify:zhaoyu	Description:修复重点医嘱新增后没有到关联医嘱的BUG	Date:2012-10-29
				obj.CPWEpStepItemGridStore.getAt(rowIndex).set('SubCatRowid',subCat)

				obj.CPWEpStepItemGridStore.getAt(rowIndex).commit(); 				
				
				/* update by zf 20110208
				var mainPanel=Ext.getCmp('main-tree');
				var stepNode=mainPanel.getNodeById(obj.StepRowid);
				var treeLoader=mainPanel.getLoader() 
				treeLoader.load(stepNode);
				*/
				obj.CPWEpStepItemGrid.getSelectionModel().selectRow(rowIndex)
				return true;
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false;
		}
  	
  }
	obj.StepItemSelect=function(){
	  	var record=obj.CPWEpStepItemGrid.getSelectionModel().getSelected();
	  	obj.CPWEpStepItemLinkARCIMEditor.stopEditing(false);
	  	obj.StepItemId=record.get("StepItemRowid");
	  	obj.CPWEpStepItemLinkARCIMGridStore.load({});
	  	obj.CPWEpStepItemLinkCNGridStore.load({});
	  	if (record.get("SubCatRowid").indexOf('2||')>=0)
	  	{
	  		obj.CPWEpStepItemLink.setActiveTab("CPWEpStepItemLinkARCIM");
	  		obj.CPWEpStepItemLink.hideTabStripItem("CPWEpStepItemLinkCN");
	  	}else{
	  		obj.CPWEpStepItemLink.setActiveTab("CPWEpStepItemLinkCN");
	  		obj.CPWEpStepItemLink.hideTabStripItem("CPWEpStepItemLinkARCIM");
	  	}
	}
	obj.ClearPathItem=function(){
			obj.StepItemId=""
			obj.PathItemDsec.setValue("");
			obj.PathItemGroupNo.setValue("");
			obj.PathItemSubCat.setValue("");
			//obj.PathItemOrdSet.setValue("");
			//obj.PathItemCheckPoint.setValue("");
			//obj.PathItemCheckDesc.setValue("");
			obj.PathARCIM=""
	}
	
	//更新一条数据
	obj.UpdatePathItem=function(StepItemRowid,allValue){
		var desc=allValue['Desc']
		var groupNo=allValue["GroupNo"];
		//*******	Modified by zhaoyu 2012-11-22 临床路径维护-路径表单维护-维护项目时，【项目分组】输入非数字的字符,保存后都变为0 173
		if ((Number(groupNo).toString()=="NaN")||(Number(groupNo)<=0)||(groupNo.indexOf(".")>0)){
			alert("项目分组错误，请输入正整数！");
			return false;
		};
		//*******
		var subCat=allValue["SubCatRowid"];
		var ordSet="";
		/*
		var ordSet=allValue["OrdSetRowid"];
		if(ordSet!=""&&StepItemRowid==obj.StepItemId){
			var item=obj.CPWEpStepItemLinkARCIMGrid.getStore().data.items;
			var rows=item.length
			if(rows!=0){
					ExtTool.alert("提示","存在可选医嘱项，不能添加医嘱套!");
					//obj.PathItemOrdSet.reset();
					return false
			}
		}
		*/
		var checkPoint="";  //allValue["CheckPoint"];
		var checkDesc="";   //allValue["CheckDesc"];
		var isMust=allValue["IsMustItem"];
		try{
			var stepItemServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItem");
			var ret = stepItemServer.UpdateStepItem(StepItemRowid,desc,groupNo,subCat,ordSet,checkPoint,checkDesc,isMust);
			if(ret<0) {
				ExtTool.alert("提示","更新失败!");
				return false;
			}else{
				//obj.PathWEpStepItemStore.load({});
				/* update by zf 20110208
				var mainPanel=Ext.getCmp('main-tree');
				var stepNode=mainPanel.getNodeById(obj.StepRowid);
				var treeLoader=mainPanel.getLoader();
				treeLoader.load(stepNode);
				*/
				return true;
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false
		}
	}
	obj.onAdd=function(){       //添加一行可编辑的输入框
		var u = new obj.CPWEpStepItemGrid.store.recordType({
							           					StepItemRowid:'',
							           					Desc:'',
							           					GroupNo:'',
							           					SubCatRowid:'',
							           					SubCat:'',
							           					OrdSetRowid:'',
							           					OrdSet:'',
							           					CheckPoint:'',
							           					CheckDesc:''
							           					
							        });
		obj.CPWEpStepItemEditor.stopEditing();	
		obj.CPWEpStepItemGrid.store.insert(0, u);
		obj.CPWEpStepItemEditor.startEditing(0);     
	}
	obj.onARCIMAdd=function(){
		/*
		if(obj.StepItemId==""){
				ExtTool.alert("提示","请选择临床路径项目!");
				return 
		}
		*/
		var record=obj.CPWEpStepItemGrid.getSelectionModel().getSelected();
		if(!record){
			ExtTool.alert("提示","请选择项目")
			return	
		}
		if(record.get('OrdSetRowid')!=""){
				ExtTool.alert("提示","存在医嘱套，不能添加可选医嘱项");
				return 
		}
		var itmNo=obj.getLinkARCIMItmNo()
		var u = new obj.CPWEpStepItemLinkARCIMGrid.store.recordType({
			Rowid:'',
			itmNo:itmNo,
			itmLinkNo:'',
			itmARCIMDR:'',
			ARCIMDesc:'',
			itmDoseQty:'',
			itmUomDr:'',
			UomDesc:'',
			itmDuratDR:'',
			DuratDesc:'',
			itmFreqDR:'',
			FreqDesc:'',
			itmInstrucDR:'',
			InstrucDesc:'',
			itmQty:'',
			itmDefaultRowid:'No',
			itmDefault:'No',
			itmIsActiveRowid:'Yes',
			itmIsActive:'Yes',
			itmIsMainRowid:'Yes',
			itmIsMain:'Yes'
		});
	 	obj.CPWEpStepItemLinkARCIMEditor.stopEditing();
		obj.CPWEpStepItemLinkARCIMGrid.store.insert(0, u);
		obj.CPWEpStepItemLinkARCIMEditor.startEditing(0);
		var arcims=obj.CPWEpStepItemLinkARCIMGrid.getStore().data.items;
		if(arcims.length<=1){
			obj.ItmDefault.setValue("Yes");
		}else{
			for(var i=1;i<arcims.length;i++){
				var itmRecord=arcims[i].data;
				var itmDefault=itmRecord['itmDefault'];
				if(itmDefault=="Yes"){
					obj.ItmDefault.setValue("No");
					return;
				}
			}	
			obj.ItmDefault.setValue("Yes");
		}
		obj.CPWEpStepItemLinkARCIMEditor.Type="add";
	}
	obj.onDelete=function(){
		obj.CPWEpStepItemLinkARCIMEditor.stopEditing(false);
		/*
		if(obj.StepItemId==""){
			alert("请选择一条记录");
			return;
		}
		*/
		var record=obj.CPWEpStepItemGrid.getSelectionModel().getSelected();
		if(!record){
			ExtTool.alert("提示","请选择要删除的项目！")
			return	
		}
		Ext.MessageBox.confirm('Confirm', '确定要删除这条项目?', function(btn,text){
			if(btn=="yes"){
					try{
						var stepItemServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItem");
						var ret = stepItemServer.DeleteStepItem(obj.StepItemId);
						if(ret<0) {
							ExtTool.alert("提示","删除失败!");
							return;
						}else{
								var record=obj.CPWEpStepItemGrid.getSelectionModel().getSelected();
								
								//Modified by wuqk 2012-03-14 gui文件中store名称变化
								//obj.PathWEpStepItemStore.remove(record)
								obj.CPWEpStepItemGridStore.remove(record);
								
								/* update by zf 20110208
								var mainPanel=Ext.getCmp('main-tree')
								var node=mainPanel.getNodeById(obj.StepItemId)
								if(node){
									node.remove();	
								}
								*/
								obj.ClearPathItem();
						}
					}catch(err){
						ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
					}
			  	return;
			}
		});
	}
	
//项目数据验证
	obj.CheckStepItem=function(allValue){
		var desc=allValue['Desc']
  	if(desc==""){
  		ExtTool.alert("Error", "项目描述不能空!", Ext.MessageBox.ERROR);
  		//obj.CPWEpStepItemEditor.showTooltip("项目描述不能空")
  		return false;
  	}
  	var groupNo=allValue['GroupNo']
  	if(groupNo==""){
  		ExtTool.alert("Error", "项目分组不能为空!", Ext.MessageBox.ERROR);
  		//obj.CPWEpStepItemEditor.showTooltip("项目分组不能为空");
  		return false;	
  	}
  	var ItemSubCat=allValue['SubCatRowid']

  	if(ItemSubCat==""){
  		ExtTool.alert("Error", "项目子类不能为空!", Ext.MessageBox.ERROR);
  		//obj.CPWEpStepItemEditor.showTooltip("项目子类不能为空")     //项目子类是必填项
  		return false;
  	}
  	return true;
	}
	//可选医嘱项数据验证
	obj.CheckARCIM=function(allValue,rowIndex){
			var itmNo=allValue['itmNo'];                        //序号
  		if(itmNo==""){
  			ExtTool.alert("Error", "项目描述不能空!", Ext.MessageBox.ERROR);
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("项目描述不能空")
  			return false
  		}
  		//序号不能重复
  		var itmLinkNo=allValue['itmLinkNo'];                 //关联号
  		//关联号检查。
  		if(itmLinkNo!=""){
	  		var checkVal=obj.CheckItmLinkNo(rowIndex,itmLinkNo);
	  		if(checkVal==0){
	  			ExtTool.alert("Error", "关联号输入不正确，请重新输入!", Ext.MessageBox.ERROR);
	  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("关联号输入不正确，请重新输入")
	  			return false;	
  		}
  	}
  		var itmARCIM=allValue['ARCIMDescRowid']; 	              //医嘱项
  		if(itmARCIM==""){
  			ExtTool.alert("Error", "请选择医嘱项!", Ext.MessageBox.ERROR);
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("请选择医嘱项!");	
  			return false
  		}
		
  		var ARCIMDesc=allValue['ARCIMDesc']; 
		if(itmARCIM==ARCIMDesc)
		{
			alert("请选择一条医嘱项!!");
			return false
		}
  		var itmDoseQty=allValue['itmDoseQty'];             //剂量
  		if(itmDoseQty==""){
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("请输入剂量!");	    //Modified By LiYang 2011-05-20  如果计量为空，不保存
  			//return false
  		}
  		var itmUom=allValue['UomDescRowid'];                     //剂量单位
  		if(itmUom==""){
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("请选择剂量单位!");	
  			//return false
  		}
  		var UomDesc=allValue['UomDesc']
  		var itmDurat=allValue['DuratDescRowid'];                  //疗程
  		if(itmDurat==""){
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("请选择疗程!");	
  			//return false
  		}
  		var DuratDesc=allValue['DuratDesc']
  		var itmFreq=allValue['FreqDescRowid'];                  //频次
  		if(itmFreq==""){
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("请选择频次!");	
  			//return false
  		}
  		//var FreqDesc=obj.ItmFreq.getRawValue();
  		var itmInstruc=allValue['InstrucDescRowid'];              //用法
  		if(itmInstruc==""){
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("请选择用法!");	
  			//return false
  		}
  		//var InstrucDesc=obj.ItmInstruc.getRawValue();
  		var itmQty=allValue['itmQty'];                      //数量
  		if(itmQty==""){
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("提示","请选择数量!");
  			//return	false
  		}
  		var itmDefault=obj.ItmDefault.getValue();
  		if(itmDefault==""){
  			ExtTool.alert("Error", "请选择默认标志!", Ext.MessageBox.ERROR);
  			//obj.CPWEpStepItemLinkARCIMEditor.showTooltip("请选择默认标志!");
  			return false
  		}
  		return true
	}
	
	//初始化关联医嘱序号
	obj.getLinkARCIMItmNo=function(){
		var item=obj.CPWEpStepItemLinkARCIMGrid.getStore().data.items;
		var rows=item.length;
		var itmNoVal=0;
		for(var i=0;i<rows;i++){
			var record=item[i].data;
			var itmNo1=record['itmNo'];
			if(itmNoVal<itmNo1) {
				itmNoVal=itmNo1;
			}
		}
		itmNoVal=parseInt(itmNoVal)+1;
		return itmNoVal;
	}
	//初始化关联项目序号
	obj.getLinkCNItmNo=function(){
		var item=obj.CPWEpStepItemLinkCNGrid.getStore().data.items;
		var rows=item.length;
		var itmNoVal=0;
		for(var i=0;i<rows;i++){
			var record=item[i].data;
			var itmNo1=record['ItemNo'];
			if(itmNoVal<itmNo1) {
				itmNoVal=itmNo1;
			}
		}
		itmNoVal=parseInt(itmNoVal)+1;
		return itmNoVal;
	}
   obj.CheckItmLinkNo=function(rowIdx,itmLinkNo){             //检查关联号的是否合法。
  	
  	var item=obj.CPWEpStepItemLinkARCIMGrid.getStore().data.items;
  	var rows=item.length
  	var checkVal=0
  	
  	if(itmLinkNo==""){
  		return;	
  	}
  	
  	for(var i=0;i<rows;i++){
  			var record=item[i].data
  			var itmNo1=record['itmNo'];
  			var itmLinkNo1=record['itmLinkNo'];
  			if(i==rowIdx){
  				continue;	
  			}
  			if(itmNo1==itmLinkNo){
  					checkVal=1
  					break;
  			}
  	}
  	return checkVal;
  }
  obj.InsertARCIM=function(allValue,rowIndex){
  		var record=obj.CPWEpStepItemLinkARCIMGrid.getStore().getAt(rowIndex);
	  	var rowid=record.get('Rowid');
	  	var newARCIM="";
  		if(allValue){
	  		newARICM=allValue['itmNo']+"^"+allValue['itmLinkNo']+"^"+allValue['ARCIMDescRowid'];
	  		newARICM=newARICM+"^"+allValue['itmDoseQty']+"^"+allValue['UomDescRowid']+"^"+allValue['DuratDescRowid'];
	  		newARICM=newARICM+"^"+allValue['FreqDescRowid']+"^"+allValue['InstrucDescRowid']+"^"+allValue['itmQty']+"^"+allValue['itmDefault'];
	  		newARICM=newARICM+"^"+rowid;
	  		//newARICM=newARICM+"^"+allValue['itmPriorityRowid']+"^"+allValue['itmIsMain']+"^"+allValue['itmGroupNo']+"^"+allValue['itmResume'];
	  		newARICM=newARICM+"^"+allValue['itmPriorityRowid']+"^"+allValue['itmIsMain']+"^"+""+"^"+allValue['itmResume'];
	  		newARICM=newARICM+"^"+allValue['itmIsActive']+"^"+allValue['itmIsMain']+"^"+""+"^"+allValue['itmResume'];
	  		newARICM=newARICM+"^"+allValue['IsActive']+"^"+session['LOGON.USERID']+"^"+""+"^"+"";
	  		if ((!allValue['itmPriorityRowid'])||(!allValue['ARCIMDescRowid'])) {
	  			ExtTool.alert("提示","类型和医嘱项为必填项目,请认真检查!");
	  			return false;
	  		}
			if (allValue['itmLinkNo']!="")		//fix by liyi 2014-12-23 关联医嘱维护默认标志必须同步
		  	{
			  	var ARCIMCount = obj.CPWEpStepItemLinkARCIMGrid.getStore().getCount();
			  	for(var i=0;i<ARCIMCount;i++){
					var objRowRec=obj.CPWEpStepItemLinkARCIMGrid.getStore().getAt(i)
					if (objRowRec.get('itmNo')==allValue['itmLinkNo']){
						var LinkPrf_itmDefault = objRowRec.get('itmDefault');
					}
				}
			  	if (allValue['itmDefault']!=LinkPrf_itmDefault){
				  	ExtTool.alert("提示","关联医嘱默认标志必须一致!请检查默认标志!");
				  	return false;
				}
			}
  		}else{
  			ExtTool.alert("提示","没有关联医嘱,请认真检查!");
  			return false;
  		}
  		
  		try{
			var stepItemServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItem");
			var ret = stepItemServer.InsertARCIM(obj.StepItemId,newARICM);
			if(ret<0) {
				ExtTool.alert("提示","可选医嘱项添加失败!");
				return false;
			}else{
					obj.CPWEpStepItemLinkARCIMGridStore.load({});
					return true
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false
		}
  	
  }
  obj.FindItem=function(rowIndex){
  	var item=obj.CPWEpStepItemLinkARCIMGrid.getStore().data.items;
  	var rows=item.length
  	var val=""
  	for(var i=0;i<rows;i++){
		if(i==rowIndex) continue;
		var record=item[i].data
		var itmNo=record['itmNo']
		var itmLinkNo=record['itmLinkNo']
		var itmARCIMDR=record['ARCIMDescRowid']
		var doseQty=record['itmDoseQty']
		var uom=record['UomDescRowid']
		var durat=record['DuratDescRowid']
		var freq=record['FreqDescRowid']
		var instruc=record['InstrucDescRowid']
		var qty=record['itmQty']
		var default1=record['itmDefault']
		var val1=itmNo+"^"+itmLinkNo+"^"+itmARCIMDR+"^"+doseQty+"^"+uom+"^"+durat+"^"+freq+"^"+instruc+"^"+qty+"^"+default1
		if(val==""){
			val=val1
		}else{
			val=val+","+val1
		}
  	}
  	return val
  }
  obj.onARCIMDelete=function(){
  	var record=obj.CPWEpStepItemLinkARCIMGrid.getSelectionModel().getSelected();
  	if(!record){
  		ExtTool.alert("提示","请选择要删除的医嘱项！")
  		return	
  	}
  	var ARCIMItmNo=record.get('itmNo');  //序号 update by zf 20110504
  	
  	Ext.MessageBox.confirm('Confirm', '确定要删除此关联医嘱项?', function(btn,text){
		if(btn=="yes"){
		  	try{
				var stepItemServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItem");
				var ret = stepItemServer.DeleteARCIM(obj.StepItemId,ARCIMItmNo);
				if(ret<0) {
					ExtTool.alert("提示","关联医嘱项删除失败!");
					return false;
				}else{
						obj.CPWEpStepItemLinkARCIMGridStore.load({});
						//obj.CPWEpStepItemLinkARCIMGridStore.remove(record)
						return true
				}
			}catch(err){
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				return false
			}
		}
  	});
  	
  }
  obj.ItmARCIMSelect=function(){
  	var stepItemServer=ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItem")
  	//检查医嘱是否有重复
  	var record=obj.CPWEpStepItemLinkARCIMGrid.getStore().getAt(obj.CPWEpStepItemLinkARCIMEditor.RowIndex)
  	var rowid=record.get('Rowid')
  	var arcimId=obj.ItmARCIM.getValue();
  	/* update by zf 2011-01-09
  	var checkVal=stepItemServer.CheckARCIM(obj.StepItemId,rowid,arcimId)
  	if(checkVal==1){
  		alert("医嘱项有重复，请重新选择！")
  		obj.ItmARCIM.reset();
  		return;
  	}*/
  	obj.ItmUomStore.load({});
  	obj.initFields();
  	var arcimStr=stepItemServer.GetArcimInfoById(obj.ItmARCIM.getValue())
  	var arcim=arcimStr.split("^")
  	if(arcim[1]=="R"){
  		obj.ItmQty.setDisabled(false)
  		obj.ItmDoseQty.setValue(arcim[3])
  		obj.ItmUomValue=arcim[4]
  		obj.ItmDurat.setValue(arcim[5])
  		obj.ItmFreq.setValue(arcim[6])
  		obj.ItmInstruc.setValue(arcim[7])
  	}else if(arcim[2]=="4"){
  		obj.ItmQty.setValue(1);
		obj.ItmDoseQty.setDisabled(true)
		obj.ItmUom.setDisabled(true)
		obj.ItmInstruc.setDisabled(true)
		obj.ItmFreq.setValue(arcim[6])
		obj.ItmDurat.setValue(arcim[5])
  	}else{
  		obj.ItmQty.setValue(1);
		obj.ItmDoseQty.setDisabled(true)
	  	obj.ItmUom.setDisabled(true)
	  	obj.ItmInstruc.setDisabled(true)
	  	obj.ItmFreq.setDisabled(true)
	  	obj.ItmDurat.setDisabled(true)
  	}
  }
  obj.initFields=function(){
  	obj.ItmUomValue=""
  	obj.ItmDoseQty.setDisabled(false)
  	obj.ItmUom.setDisabled(false)
  	obj.ItmInstruc.setDisabled(false)
  	obj.ItmQty.setDisabled(false)
  	obj.ItmFreq.setDisabled(false)
  	obj.ItmDurat.setDisabled(false)
  	obj.ItmDoseQty.reset();
  	obj.ItmUom.reset();
  	obj.ItmInstruc.reset();
  	obj.ItmInstruc.reset();
  	obj.ItmQty.reset();
  	obj.ItmFreq.reset();
  	obj.ItmDurat.reset();
  	obj.ItmResume.reset();
  }
  
  	obj.OnLinkItemAdd=function(){
		var record=obj.CPWEpStepItemGrid.getSelectionModel().getSelected();
		if(!record){
			ExtTool.alert("提示","请选择项目")
			return
		}
		var itmNo=obj.getLinkCNItmNo();
		var u = new obj.CPWEpStepItemLinkCNGrid.store.recordType({
			ItemID:'',
			ItemNo:itmNo,
			ItemCategRowid:'',
			ItemCateg:'',
			ItemDicRowid:'',
			ItemDic:'',
			GroupNo:'',
			IsActive:'Yes',
			UpdateUser:'',
			UpdateDate:'',
			UpdateTime:''
		});
	 	obj.CPWEpStepItemLinkCNEditor.stopEditing();
		obj.CPWEpStepItemLinkCNGrid.store.insert(0, u);
		obj.CPWEpStepItemLinkCNEditor.startEditing(0);
		obj.CPWEpStepItemLinkCNEditor.Type="add";
	}
	
	obj.OnLinkItemDelete=function(){
	  	var record=obj.CPWEpStepItemLinkCNGrid.getSelectionModel().getSelected();
	  	if(!record){
	  		ExtTool.alert("提示","请选择要删除的关联项！")
	  		return	
	  	}
	  	var ItemNo=record.get('ItemNo');
	  	
	  	Ext.MessageBox.confirm('Confirm', '确定要删除此阶段?', function(btn,text){
			if(btn=="yes"){
		  		try{
					var stepItemServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItemLnk");
					var ret = stepItemServer.DeleteLinkCN(obj.StepItemId,ItemNo);
					if(ret<0) {
						ExtTool.alert("提示","关联项目删除失败!");
						return false;
					}else{
						obj.CPWEpStepItemLinkCNGridStore.load({});
						return true
					}
				}catch(err){
					ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
					return false
				}
			}
	  	});
	}
	
	
	//可选关联项数据验证
	obj.CheckLinkCN=function(allValue,rowIndex)
	{
		var ItemNo=allValue['ItemNo'];                        //序号
  		if(ItemNo==""){
  			ExtTool.alert("Error", "序号不能空!", Ext.MessageBox.ERROR);
  			return false
  		}
  		var ItemDicRowid=allValue['ItemDicRowid'];                 //关联项
  		if(ItemDicRowid==""){
  			ExtTool.alert("Error", "关联项不能空!", Ext.MessageBox.ERROR);
  			return false
  		}
  		return true
	}
	
	obj.InsertLinkCN=function(allValue,rowIndex){
  		var record=obj.CPWEpStepItemLinkCNGrid.getStore().getAt(rowIndex);
	  	var newLinkCN="";
  		if(allValue){
	  		newLinkCN=allValue['ItemNo']+"^"+allValue['ItemDicRowid'];
	  		//newLinkCN=newLinkCN+"^"+allValue['GroupNo'];
	  		newLinkCN=newLinkCN+"^"+"";
	  		newLinkCN=newLinkCN+"^"+allValue['IsActive']+"^"+session['LOGON.USERID']+"^"+""+"^"+"";
	  		if ((!allValue['ItemDicRowid'])||(!allValue['ItemNo'])) {
	  			ExtTool.alert("提示","序号和关联项为必填项目,请认真检查!");
	  			return false;
	  		}
  		}else{
  			ExtTool.alert("提示","没有关联诊疗护理项目,请认真检查!");
  			return false;
  		}
  		try{
			var stepItemServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItemLnk");
			var ret = stepItemServer.InsertLinkCN(obj.StepItemId,newLinkCN);
			if(ret<0) {
				ExtTool.alert("提示","可选医嘱项添加失败!");
				return false;
			}else{
					obj.CPWEpStepItemLinkCNGridStore.load({});
					return true
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false
		}
	}
	
	obj.LnkItemCateg_OnExpand=function(){
		obj.LnkItemCategStore.removeAll();
	  	obj.LnkItemCategStore.load({});
	}
	obj.LnkItemDic_OnExpand=function(){
		obj.LnkItemDicStore.removeAll();
	  	obj.LnkItemDicStore.load({});
	}
}