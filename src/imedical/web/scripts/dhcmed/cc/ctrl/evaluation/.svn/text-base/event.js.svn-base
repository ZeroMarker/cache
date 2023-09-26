
function InitEvalWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.btnUpdate.on("click", obj.btnUpdate_OnClick, obj);
		obj.gpEvalRst.on("rowclick", obj.gpEvalRst_rowclick, obj);
	};
	obj.gpEvalRst_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.gpEvalRstStore.getAt(rowIndex);
		if ((obj.EvalID)&&(objRec.get("EvalID")==obj.EvalID)){
			obj.ClearFormData();
		}else{
			obj.EvalID=objRec.get("EvalID");
			obj.EvalDate=objRec.get("EvalDate");
			obj.EvalTime=objRec.get("EvalTime");
			obj.txtEvalInfo.setValue(objRec.get("EvalInfo"));
			obj.chkIsActive.setValue((objRec.get("IsActive")=='Yes'));
		}
	}
	obj.ClearFormData = function(){
		obj.EvalID="";
		obj.EvalDate="";
		obj.EvalTime="";
		obj.txtEvalInfo.setValue("");
		obj.chkIsActive.setValue(true);
	}
	obj.btnUpdate_OnClick = function(){
		var evalInfo="",isActive="",errInfo="";
		evalInfo=obj.txtEvalInfo.getValue();
		if (evalInfo==''){
			ExtTool.alert("提示","评价信息不允许为空，请认真填写评价信息!");
			return;
		}
		if (obj.chkIsActive.checked) {
			isActive="Y";
		}else{
			isActive="N";
		}
		
		try
		{
			var InputStr=obj.EvalID+"^";
			InputStr=InputStr+obj.SubjectID+"^";
			InputStr=InputStr+obj.EpisodeID+"^";
			InputStr=InputStr+obj.EvalDate+"^";
			InputStr=InputStr+obj.EvalTime+"^";
			InputStr=InputStr+obj.EvalUserID+"^";
			InputStr=InputStr+obj.EvalLocID+"^";
			InputStr=InputStr+evalInfo+"^";
			InputStr=InputStr+isActive+"^";
			InputStr=InputStr+"";
			var clsEvaluation = ExtTool.StaticServerObject("DHCMed.CC.Evaluation");
			var ret = clsEvaluation.Update(InputStr);
			if (ret>0){
				//obj.gpEvalRstStore.load({});
				obj.EvalWindow.close();
				if(window.refreshDataGrid){
					window.refreshDataGrid.call(obj);
				}
			}else{
				ExtTool.alert("提示","更新数据错误!");
			}
			
		}catch(e){
			ExtTool.alert("错误", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
		}
	}
}

function EvaluationLookUpHeader(SubjectID,EpisodeID)
{
    	var objEvalWindow = new InitEvalWindow(SubjectID,EpisodeID);
        objEvalWindow.EvalWindow.show();
		var numTop=(document.body.clientHeight-objEvalWindow.EvalWindow.height)/2;
		var numLeft=(document.body.clientWidth-objEvalWindow.EvalWindow.width)/2;
		objEvalWindow.EvalWindow.setPosition(numLeft,numTop);
        ExtDeignerHelper.HandleResize(objEvalWindow);
}