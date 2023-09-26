
function InitviewScreenEvent(obj) {
	obj.objCurrRec = null;
	
	obj.LoadEvent = function(args)
  {};
  
  
	obj.btnSave_click = function()
	{
		if(obj.txtCode.getValue() == "")
		{
			ExtTool.alert("提示", "请输入代码!", Ext.MessageBox.INFO);
			return;	
		}
		if(obj.txtDesc.getValue() == "")
		{
			ExtTool.alert("提示", "请输入描述!", Ext.MessageBox.INFO);
			return;	
		}		
		if(obj.txtKind.getValue() == "")
		{
			ExtTool.alert("提示", "请输入类别!", Ext.MessageBox.INFO);
			return;	
		}				
		if(obj.cboProduct.getValue() == "")
		{
			ExtTool.alert("提示", "请选择产品!", Ext.MessageBox.INFO);
			return;	
		}	
		var strArg = "";
		if(obj.objCurrRec != null)
			strArg = obj.objCurrRec.RowID + "^";
		else
			strArg = "^";
		strArg += obj.txtCode.getValue() + "^";
		strArg += obj.txtDesc.getValue() + "^";
		strArg += obj.txtKind.getValue() + "^";
		strArg += obj.cboProduct.getValue() + "^";
		strArg += obj.cboHospital.getValue() + "^";
		strArg += obj.txtResume.getValue() + "^";
		
		var ret = ExtTool.RunServerMethod("DHCMed.SS.ReportConfig", "Update", strArg, "");
		if(ret > 0)
		{
			ExtTool.alert("提示", "保存成功!", Ext.MessageBox.INFO);
			obj.gridResultStore.load({});
		}
	};
	
	obj.btnEditItems_click = function()
	{
		if(obj.objCurrRec == null)
			return;
		var objProduct = ExtTool.RunServerMethod("DHCMed.SS.Products", "GetObjById", obj.objCurrRec.ProductDr);
		var objFrm = new InitwinConfigEdit(obj.objCurrRec.HospitalDr, objProduct.ProCode, obj.objCurrRec.Kind, obj.objCurrRec.Code, obj.objCurrRec.RowID);
		objFrm.winConfigEdit.show();
		
	};
	
	obj.gridResult_rowclick = function(objGrid, rowIndex, eventObj){
		var objCurrRec = obj.gridResultStore.getAt(rowIndex);
		if(obj.objCurrRec == null)
		{
			obj.DisplayRecord(objCurrRec.get("RowID"));
		}
		else
		{
			if(obj.objCurrRec.RowID == objCurrRec.get("RowID"))
			{
				obj.objCurrRec = null;
				obj.txtCode.setValue("");
				obj.txtDesc.setValue("");
				obj.cboProduct.clearValue();
				obj.cboHospital.clearValue();
				
				//Modified By LiYang 2014-07-15 FixBug:1343 系统管理-智能报表配置－双击一条【类型】和【备注】不为空的记录，报表配置信息中【类型】和【备注】信息依然存在
				obj.txtKind.setValue("");
				obj.txtResume.setValue("");
			}
			else
			{
				obj.DisplayRecord(objCurrRec.get("RowID"));
			}
		}
	}
	
	obj.DisplayRecord = function(RowID){
			obj.objCurrRec = ExtTool.RunServerMethod("DHCMed.SS.ReportConfig", "GetObjById", RowID);
			obj.txtCode.setValue(obj.objCurrRec.Code);
			obj.txtDesc.setValue(obj.objCurrRec.Description);
			obj.txtResume.setValue(obj.objCurrRec.Resume);
			obj.txtKind.setValue(obj.objCurrRec.Kind);
			obj.cboProduct.clearValue(obj.objCurrRec.ProductDr);
			obj.cboHospital.clearValue(obj.objCurrRec.HospitalDr);		
			obj.cboProductStore.load({
				callback : function(){
					if(obj.objCurrRec.ProductDr != 0)
						obj.cboProduct.setValue(obj.objCurrRec.ProductDr);
					else
						obj.cboProduct.clearValue();					
				}	
			});
			obj.cboHospitalStore.load({
				callback : function(){
					if(obj.objCurrRec.HospitalDr != 0)
						obj.cboHospital.setValue(obj.objCurrRec.HospitalDr);
					else
						obj.cboHospital.clearValue();
				}	
			});					
	}
	
/*viewScreen新增代码占位符*/}


function InitwinConfigEditEvent(obj)
{	obj.LoadEvent = function(args)
	{
	}
	
	obj.btnDtlAdd_click = function()
	{
		var objRec = new Ext.data.Record({});
		objRec.set("RowID", "");
		objRec.set("ParentID", obj.Parref);
		objRec.set("值1", "");
		objRec.set("值2", "");
		obj.gridConfigItemStore.add([objRec]);
	}
	
	obj.btnDtlDelete_click = function()
	{
		if(obj.gridConfigItem.getSelectionModel().selection == null)
			return;
		var objSelRec = obj.gridConfigItem.getSelectionModel().selection.record;
		if(objSelRec == null)
			return;
		if((objSelRec.get("RowID") != "") && (objSelRec.get("RowID") != null))
		{
			ExtTool.RunServerMethod("DHCMed.SS.ReportConfigItem", "Delete", objSelRec.get("RowID"));
		}
		obj.gridConfigItemStore.remove(objSelRec);
	}
	
	obj.btnDtlCancel_click = function(){
		obj.winConfigEdit.close();
	}
	
	obj.btnDtlSave_click = function(){
		var objRec = null;
		var strArg = "";
		var RowID= "";
		for(var i = 0; i < obj.gridConfigItemStore.getCount(); i ++)
		{
			objRec = obj.gridConfigItemStore.getAt(i);
			if(!objRec.dirty)
				continue;
			strArg = objRec.get("RowID") + "^";
			strArg += objRec.get("ParentID") + "^";
			strArg += objRec.get("代码") + "^";
			strArg += objRec.get("值1") + "^";
			strArg += objRec.get("值2") + "^";
			if((objRec.get("代码")=="")||((objRec.get("值1")=="")&&(objRec.get("值2")=="")))
			{
				ExtTool.alert("提示", "代码和值不能为空!", Ext.MessageBox.INFO);
				return;	
			}		
			RowID = ExtTool.RunServerMethod("DHCMed.SS.ReportConfigItem", "Update", strArg, "^");
			objRec.set("RowID", RowID);
			objRec.commit();
		}
	}
/*winConfigEdit新增代码占位符*/
}
