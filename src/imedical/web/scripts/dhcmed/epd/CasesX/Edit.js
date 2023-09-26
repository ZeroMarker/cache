
function InitwinEdit(objInput){
	
	var obj = new Object();
	obj.Handle = new Object();
	
	obj.Handle.ID     = objInput.CasesXID;	
	obj.Handle.EpisodeID = objInput.EpisodeID;
	obj.Handle_Opinion = Common_TextArea("Handle_Opinion","处置意见",80);
	obj.Handle_EpdDiagnos = Common_ComboToEPDICD("Handle_EpdDiagnos","确诊诊断");
	
	obj.Handle_btnConfirm = new Ext.Button({
		id : 'Handle_btnConfirm'
		,iconCls : 'icon-confirm'
		,text : '确诊'
		,listeners : {
			'click' : function(){
				if(obj.Handle.ID=="") return;
				var aSubjectCode=SubjectCode;
				var aEpisodeID=obj.Handle.EpisodeID;
				var aCasesxID=obj.Handle.ID;
				var aOperation="1";
				var aLocID=session['LOGON.CTLOCID'];
				var aUserID=session['LOGON.USERID']
				var aOpinion=Common_GetValue('Handle_Opinion');
				var aDiagnosID=Common_GetValue('Handle_EpdDiagnos');
				var aDiagnosDesc=Common_GetText('Handle_EpdDiagnos');
				if ((!aDiagnosDesc)||(!aDiagnosID)) {
					ExtTool.alert("提示", "确诊诊断不允许为空,请选择一个标准传染病诊断!");
					return;
				}
				if (aOpinion ==''){
					ExtTool.alert("提示", "处置意见不允许为空,请填写处置意见!");
					return;
				}
			    
				var ret = ExtTool.RunServerMethod("DHCMed.EPDService.CasesXSrv","ProcCasesHandle",aSubjectCode,aCasesxID,aOperation,aDiagnosID,aOpinion,aLocID,aUserID);
				if(ret>0){
					ExtTool.alert("提示", "确诊处置成功!");
					obj.winEdit.close();
					
					//CasesXWindowRefresh_Handler();
					Common_LoadCurrPage('gridCasesX',1);
				}else{
					ExtTool.alert("提示", "确诊处置失败!");	    
				}
				return;
			}
		}
     });
     
     obj.Handle_btnExclude = new Ext.Button({
		id : 'Handle_btnExclude'
		,iconCls : 'icon-delete'
		,text : '排除'
		,listeners : {
			'click' : function(){
				if(obj.Handle.ID=="") return;
				
				var aSubjectCode=SubjectCode;
				var aEpisodeID=obj.Handle.EpisodeID;
				var aCasesxID=obj.Handle.ID;
				var aOperation="0";
				var aLocID=session['LOGON.CTLOCID'];
				var aUserID=session['LOGON.USERID']
				var aOpinion=Common_GetValue('Handle_Opinion'); 
			    var aDiagnosID = obj.Handle_EpdDiagnos.getValue();
			   
			    if (aOpinion!=""){    
					var ret = ExtTool.RunServerMethod("DHCMed.EPDService.CasesXSrv","ProcCasesHandle",aSubjectCode,aCasesxID,aOperation,aDiagnosID,aOpinion,aLocID,aUserID);
			    	if (ret>0){
						ExtTool.alert("提示", "排除处置成功!");
						obj.winEdit.close();
			        	//CasesXWindowRefresh_Handler();
			    		Common_LoadCurrPage('gridCasesX',1);
					}else{
						ExtTool.alert("提示", "排除处置失败!");
					}
			    }else{
				    ExtTool.alert("提示", "请输入处置意见!");
				    return;
			    }
			}
		}
     });
    obj.Handle_btnClose = new Ext.Button({
		id : 'Handle_btnClose'
		,iconCls : 'icon-close'
		,text : '关闭'
		,listeners : {
			'click' : function(){
				obj.winEdit.close();
			}
		}
    });
    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 180
		,region : 'center'
		,layout : 'form'
		,frame : true
		,items:[
		    obj.Handle_EpdDiagnos
			,obj.Handle_Opinion
		]
		,buttons:[
			obj.Handle_btnConfirm
			,obj.Handle_btnExclude
			,obj.Handle_btnClose
		]
	});
	
	
	obj.winEdit = new Ext.Window({
		id : 'winEdit'
		,buttonAlign : 'center'
		,width : 300
		,height : 200
		,title : '请填写处置意见...'
		,layout : 'fit'
		,modal : true
		,renderTo : document.body
		,items:[
			obj.fPanel
		]
	});

  return obj;
}

//调用页面刷新
function CasesXWindowRefresh_Handler(){
	if (typeof WindowRefresh_Handler == 'function'){
		WindowRefresh_Handler();
	}
}

