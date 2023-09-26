
function InitVarWindowEvent(obj)
{
	obj.LoadEvent = function(args){
		obj.cboVarCateg.on("expand", obj.cboVarCateg_OnExpand, obj);
		obj.cboVarCateg.on("collapse", obj.cboVarCateg_OnCollapse, obj);
		obj.cboVarReason.on("expand", obj.cboVarReason_OnExpand, obj);
		obj.btnClose.on("click", obj.btnClose_OnClick, obj);
		obj.btnUpdate.on("click", obj.btnUpdate_OnClick, obj);
	}
	obj.cboVarCateg_OnExpand = function(){
		obj.cboVarCateg.clearValue();
		obj.cboVarCategStore.load({});
	}
	obj.cboVarCateg_OnCollapse = function(){
		obj.cboVarReason.clearValue();
	}
	obj.cboVarReason_OnExpand = function(){
		obj.cboVarReason.clearValue();
		obj.cboVarReasonStore.load({});
	}
	obj.btnClose_OnClick = function(){
		window.close();
	}
	obj.btnUpdate_OnClick = function(){
		
		var objClinPathWaysVariance = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysVariance");
		
		var ErrInfo="";
		var varReason=obj.cboVarReason.getValue();
		if (!varReason){
			ErrInfo = ErrInfo + "请选择变异原因,变异原因不允许为空!";
		}
		//******* zhaoyu 2013-01-05 表单外医嘱变异备注没有保存上 156
		var varReasonResume=obj.txtaVarResume.getValue();
		var varReasonDesc=obj.cboVarReason.getRawValue();
		if ((varReasonDesc.indexOf('其他')>=0)&&(varReasonResume=='')){
			ErrInfo = ErrInfo + "请填写原因备注,备注不允许为空!";
		}
		//*******
		/*	Note by zhaoyu 2013-01-05
		var varReasonResume="";  //add by wangcs 2012-12-20
		//update by zf 2012-04-18
    var varReasonDesc=obj.cboVarReason.getRawValue();
    if (varReasonDesc.indexOf('其他') >= 0)
    {
       varReasonResume=obj.txtaVarResume.getValue();
      if (varReasonResume==''){
        ErrInfo = ErrInfo + "请填写原因备注,备注不允许为空!";
      }
    }
		*/

		if (ErrInfo) {
			alert(ErrInfo);
			return;
		}
		
		var InputStr=obj.EpisodeID;
		InputStr=InputStr + "^" + varReason;
		InputStr=InputStr + "^" + varReasonResume;
		InputStr=InputStr + "^" + obj.UserID;
		InputStr=InputStr + "^" + obj.ArcimIDs;
		var ret = objClinPathWaysVariance.UpdateExtraVar(InputStr);
		if (ret<0){
			ExtTool.alert("提示","变异原因填写错误!",Ext.MessageBox.ERROR);
			window.returnValue=false;
		}else{
			window.returnValue=true;
			window.close();
		}
	}
}
