
function InitwinEdit(objInput){
	
	var obj = new Object();
	obj.Handle = new Object();
	
	obj.Handle.ID     = objInput.CasesXID;	
	obj.Handle.EpisodeID = objInput.EpisodeID;
	obj.Handle_Opinion = Common_TextArea("Handle_Opinion","�������",80);
	obj.Handle_EpdDiagnos = Common_ComboToEPDICD("Handle_EpdDiagnos","ȷ�����");
	
	obj.Handle_btnConfirm = new Ext.Button({
		id : 'Handle_btnConfirm'
		,iconCls : 'icon-confirm'
		,text : 'ȷ��'
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
					ExtTool.alert("��ʾ", "ȷ����ϲ�����Ϊ��,��ѡ��һ����׼��Ⱦ�����!");
					return;
				}
				if (aOpinion ==''){
					ExtTool.alert("��ʾ", "�������������Ϊ��,����д�������!");
					return;
				}
			    
				var ret = ExtTool.RunServerMethod("DHCMed.EPDService.CasesXSrv","ProcCasesHandle",aSubjectCode,aCasesxID,aOperation,aDiagnosID,aOpinion,aLocID,aUserID);
				if(ret>0){
					ExtTool.alert("��ʾ", "ȷ�ﴦ�óɹ�!");
					obj.winEdit.close();
					
					//CasesXWindowRefresh_Handler();
					Common_LoadCurrPage('gridCasesX',1);
				}else{
					ExtTool.alert("��ʾ", "ȷ�ﴦ��ʧ��!");	    
				}
				return;
			}
		}
     });
     
     obj.Handle_btnExclude = new Ext.Button({
		id : 'Handle_btnExclude'
		,iconCls : 'icon-delete'
		,text : '�ų�'
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
						ExtTool.alert("��ʾ", "�ų����óɹ�!");
						obj.winEdit.close();
			        	//CasesXWindowRefresh_Handler();
			    		Common_LoadCurrPage('gridCasesX',1);
					}else{
						ExtTool.alert("��ʾ", "�ų�����ʧ��!");
					}
			    }else{
				    ExtTool.alert("��ʾ", "�����봦�����!");
				    return;
			    }
			}
		}
     });
    obj.Handle_btnClose = new Ext.Button({
		id : 'Handle_btnClose'
		,iconCls : 'icon-close'
		,text : '�ر�'
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
		,title : '����д�������...'
		,layout : 'fit'
		,modal : true
		,renderTo : document.body
		,items:[
			obj.fPanel
		]
	});

  return obj;
}

//����ҳ��ˢ��
function CasesXWindowRefresh_Handler(){
	if (typeof WindowRefresh_Handler == 'function'){
		WindowRefresh_Handler();
	}
}

