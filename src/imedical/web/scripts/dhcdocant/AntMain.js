/*!
 * ��д����:2012-07-23
 * V 1.0
 * ���ߡG�����
 * ˵���G����ҩ�����
 * ���ơGAntMain.js
 V 2.1 
 * Date :
 
 V 2.0  
 * Date : 
 
 */
var ExtToolSetting=new Object();
AntMain=function(ShowTabStr,EpisodeID,ArcimRowid,AntibApplyRowid,UserReasonId,OrderPoisonCode){
		this.ShowTabStr=ShowTabStr
		this.EpisodeID=EpisodeID 
		this.ArcimRowid=ArcimRowid
		this.AntibApplyRowid=AntibApplyRowid
		this.UserReasonId=UserReasonId
		this.UserReasonDesc=""
		this.AntBodyPartDesc=""
		this.OrderPoisonCode=OrderPoisonCode
		//this.wantFlag=""
		
		//var wantAudit=false
		//var wantConsultation=false
		var flag=false;
		// ****  ��ӻ����ж�
		var LocID=session['LOGON.CTLOCID'];
		var NeedConsultOBJ=ExtTool.StaticServerObject("web.DHCDocAntiCommon");
		var NeedConsult=NeedConsultOBJ.IsNeedConsult(LocID)
		// ****  �����ж���Ϣ
		var UserCode=session['LOGON.USERCODE'];
		var GetWantFlagObj=ExtTool.StaticServerObject("web.DHCDocAntibioticReason");
		var WantFlagStr=GetWantFlagObj.GetWantFlag(UserCode,this.OrderPoisonCode);
		var WantFlagArr=WantFlagStr.split("^");
		//alert(WantFlagArr)
		//this.wantAudit=(WantFlagArr[0]=="1");
		//this.wantConsultation=(WantFlagArr[1]=="1");
		if(this.ShowTabStr.indexOf("Apply")>=0){
			wantAudit=true;
			}
		if((this.ShowTabStr.indexOf("Consult")>=0)&&(NeedConsult==1)){
			wantConsultation=true;
			}
		this.CareType=WantFlagArr[2];
		// ****  ���� Arcim ȡҩƷ��Ϣ
		var GetArcimObj=ExtTool.StaticServerObject("web.DHCDocAntibioticReason");
		var ArcimDetailStr=GetArcimObj.GetArcimDetailByArcim(this.ArcimRowid);
		var ArcimDetaiArr=ArcimDetailStr.split("^");
		this.Arcim=ArcimDetaiArr[0];
		this.Arcic=ArcimDetaiArr[1];
		this.Poison=ArcimDetaiArr[2];
		this.phDDD=ArcimDetaiArr[3];
		this.ArcimDesc=this.Arcim+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+this.Arcic+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+this.Poison+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"DDD:"+this.phDDD
	
		
		
		// ****  ȡҽ����ְ����Ϣ
		this.DoctorInfo=session['LOGON.USERNAME'] + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+this.CareType
		
		if (wantAudit){this.DoctorInfo+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"<font color='red'><B>��Ҫ���</B></font>";}
		if (wantConsultation){this.DoctorInfo+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"<font color='red'><B>��Ҫ����</B></font>";}
		
		// **** SeqNoValue
		// **** �����Ƿ񱣴�ı��
		//this.SaveFlag=false;
		
		this.baseInfo=new Ext.form.FieldSet({
		
		//this.baseInfo=new Ext.Panel({
			title: '������Ϣ',
			iconCls:"c-baseinfo-icon",
            collapsible: true,
            autoHeight:true,
            defaultType: 'label',
            items :[{
                    fieldLabel: '����ҩ����Ϣ',
                    html: this.ArcimDesc    // ҩ�������Ϣ
                },{
                    fieldLabel: 'ҽ&nbsp;&nbsp;ʦ&nbsp;&nbsp;��&nbsp;&nbsp;Ϣ&nbsp;',
                    html: this.DoctorInfo                 //  ҽʦ��Ϣ
                }]
              });
	  this.btnSave = new Ext.Button({
				id : 'btnSave'
				,text : '����',
				iconCls:"c-btn-save",
				scope:this,
				handler: function(){
	  			this.SaveData()            
	  		}
		});
		this.btnCancel=new Ext.Button({
				id:'btnCancel',
				text:'ȡ��',
				iconCls:'c-btn-cancel',
				scope:this,
				handler:function(){
						window.close();
				}
		});
		this.panel = new Ext.Panel({
			layout:'fit',
			buttonAlign : 'center',
			autoScroll:true,
			frame:true,
			items : [this.baseInfo],
			buttons:[this.btnSave,this.btnCancel]
		});
		AntMain.superclass.constructor.call(this,{
				//id:'main-Ant',				
				// Modified by wuqk 2013-01-22 to show in csp page
				//height:600,
				//width:800,
				//title:'����ҩ��ǼǱ�',
				//layout:'fit',
				region : 'center',
				closeAction:'close',
				resizable:false,
				closable:true,
				modal:true,
				items:[this.panel]
		})
		
		this.AntReasonPan=new AntReasonPan(this.EpisodeID,this.ArcimRowid,UserReasonId,this.OrderPoisonCode)
		this.panel.add(this.AntReasonPan);
		
		if (wantAudit){
			this.AntApplyPan=new AntApplyPan(this.EpisodeID,this.ArcimRowid,this.AntibApplyRowid,this.OrderPoisonCode,this.ShowTabStr);
			this.panel.add(this.AntApplyPan);
		}
		
		
		if (wantConsultation){
			this.AntConsultation=new AntConsultation(this.EpisodeID,this.ArcimRowid,this.AntibApplyRowid,this.OrderPoisonCode);
			this.panel.add(this.AntConsultation);
		}
		//this.on("beforeclose",this.CloseWin,this)
		
}



// Modified by wuqk 2013-01-22 to show in csp page
//Ext.extend(AntMain,Ext.Window,{
Ext.extend(AntMain,Ext.Panel,{
	AntMainReturn: "",
	CloseWin:function(){
		var ParentOrdPri;
		//window.returnValue
		if (!SaveFlag){
			this.AntMainReturn = ""
					/*var flag=confirm("�ǼǱ�δ����,�Ƿ�����˳�?",true)
					if(flag){
						this.AntMainReturn = "" ;
							//var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
							//if(objtbl){
							//		DeleteTabRow(objtbl,FocusRowIndex);		
							//}
							//return this.AntMainReturn;
					}else{
							//return false;	
					}	*/
			}else{
				if ((wantAudit)&&(Ext.getCmp('isEmergency').checked==true)){
							OrderInsID=Ext.getCmp('OrderIns').getValue();
							OrderInsDesc=Ext.getCmp('OrderIns').getRawValue();
							this.AntMainReturn = UserReasonId+"!"+AntibApplyRowid+"!"+OrderInsID+"!"+OrderInsDesc+"!"+"isEmergency";
				}
				else if((!wantAudit)&&(!wantConsultation)){
					this.AntMainReturn =UserReasonId+"!"+"!"+"!"+"!";
				}else{
					this.AntMainReturn = "";
				}
				
			}
			window.returnValue = this.AntMainReturn;
			return;
	},SaveData:function(){
		//ͳһ����ʹ��Ŀ��/������Ϣ/�������룬�����ύ���رմ���
		
		var ReasonInfo="";
		var AuditInfo="";
		var Consultation="";
		var PriorRowid=""
		//var UserReasonId=""
		//var AntibApplyRowid=""
	
		if (!this.AntReasonPan.CheckBeforeUpdate()){ return;}
		else{ReasonInfo=this.AntReasonPan.GetReason();}
		var InsertObj=ExtTool.StaticServerObject("web.DHCDocAntibioticReason");
		var ret=InsertObj.Insert(ReasonInfo);
		var retArr=ret.split("^")
		var rtn=retArr[0]
		if(rtn==0){
			UserReasonId=retArr[1]
			if((!wantAudit)&&(!wantConsultation)){
				alert("����ɹ���");	
				SaveFlag=true;
				//this.close();
				window.close();
				return;
				}
			}else{
				alert("������Ϣ����ʧ��!");	
				return;
				}
		if (wantAudit){
			if (!this.AntApplyPan.CheckBeforeUpdate()) return;
			else{AuditInfo=this.AntApplyPan.GetApplyInfo(UserReasonId);}	
		}
		if (wantConsultation){
			if (!this.AntConsultation.CheckBeforeUpdate()) return;
			else{  Consultation=this.AntConsultation.GetConsultation(UserReasonId);}
		}
		if ((wantAudit)&&(wantConsultation)){
			//alert(""����ɻ�������ˡ�!");	
			}
		var ParaAll=AuditInfo+"&"+Consultation
		var InsertAllObj=ExtTool.StaticServerObject("web.DHCDocAntibioticReason");
		this.ReSult= InsertAllObj.InserAllInfo(ParaAll);
		var RsArr=this.ReSult.split("^")
		var Rs=RsArr[0]
		if (Rs==0){
			alert("����ɹ���!");	
			SaveFlag=true;
			AntibApplyRowid=RsArr[1]
			//this.close();
			window.close();
			return;
			}else{
				alert("����ʧ�ܣ�!");	
				}
		
		//Save 
		//this.SaveFlag=true;
		//this.close();
		
	}
})
Ext.reg('mainAntWindow',AntMain)
//������ʹ��Ŀ�ĵ����Ĵ��ڵ�������






/*!
 * ��д����:2012-07-23
 * ���ߡG�����
 * ˵���G����ҩ��������ʹ��Ŀ�ı������
 * ���ơGAntMain.js
 */
AntReasonPan=function(EpisodeID,ArcimRowid,UserReasonId,OrderPoisonCode){
		var flag=false;
		var Opflag=false;
		this.EpisodeID=EpisodeID
		this.ArcimRowid=ArcimRowid
		this.UserReasonId=UserReasonId
		this.OrderPoisonCode=OrderPoisonCode
		this.UserReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		this.UserReasonStore = new Ext.data.Store({
				proxy: this.UserReasonStoreProxy,
				reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
				,{name: 'Rowid', mapping: 'Rowid'}
			])
		});
		this.UserReason = new Ext.form.ComboBox({
			id :'UserReason'
			,minChars : 1
			,store : this.UserReasonStore
			,valueField : 'Rowid'
			,fieldLabel : "ʹ��Ŀ��<font color='red'>*</font>",
			allowBlank:false,
			emptyText:"��ѡ��ʹ��Ŀ��"
			,displayField : 'desc'
			,triggerAction : 'all',
			editable:false,
			width:200,
			//anchor : '99%',
			listeners:{
						select:function(x,R,curindex){
							if((R.data.desc.indexOf("Ԥ��-����")>=0)){
								Ext.getCmp('AntSSYFTime').enable();
								}else{
									if (typeof(Ext.getCmp('AntSSYFTime'))!="undefined"){
										Ext.getCmp('AntSSYFTime').disable();
										Ext.getCmp('AntSSYFTime').setValue("");
										Ext.getCmp('AntSSYFTime').setRawValue("");
										}
									}
							//alert(Ext.getCmp('AntOperation'));
							Ext.getCmp('AntOperation').getSelectionModel().clearSelections();
							Opflag=false;
							}
				}
		});
		this.UserReasonStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocAntibioticReason';
			param.QueryName = 'GetAntReason';
			param.Arg1 = this.OrderPoisonCode;    
			param.ArgCnt=1;
		},this);
		this.CauseAna=new Ext.form.TextField({
				id:'CauseAna',
				fieldLabel:'����ԭ��&nbsp;'
				,width:200
				//,anchor : '99%'
		});
		this.AntIndicationsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		this.AntIndicationsStore = new Ext.data.Store({
				proxy:this.AntIndicationsStoreProxy,
				reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
				,{name: 'Rowid', mapping: 'Rowid'}
			])
		});
		this.AntIndications = new Ext.form.ComboBox({
			id :'AntIndications'
			,minChars : 1
			,store : this.AntIndicationsStore
			,valueField : 'Rowid'
			,fieldLabel : "��ҩָ��<font color='red'>*</font>",
			allowBlank:false,
			width:200,
			emptyText:"��ѡ��ָ��"
			,displayField : 'desc'
			,triggerAction : 'all',
			editable:false,
			listeners:{
						select:function(x,R,curindex){
							if((R.data.desc.indexOf("����")>=0)){
									alert("����д����ԭ��!");
								}
							if(R.data.desc.indexOf("��ͨ����")>=0){
									ExtTool.alert("��ʾ","1�����ɹ����޲�����������Ƭ�޲�������2����״�ټ���������3�����ټ���������4���ؽھ����������5����������Ĥ����������6��­�������г�������7����Ѫ��;�������������  ԭ���ϲ���ʹ�ÿ���ҩ�����I���п�����Ԥ��ʹ�ÿ���ҩ��ʱ��ԭ���ϲ�����24Сʱ ");
									}
							if(R.data.desc.indexOf("���п�")>=0){
									ExtTool.alert("��ʾ","���п�������׼ʹ�ÿ���ҩ��")
									x.setValue("")
									x.setRawValue("")
								}
							if(Ext.getCmp('UserReason').getRawValue().indexOf("�������")>=0){
								//alert(1) delete by qp 2014-04-21
								if(R.data.desc.indexOf(">3Сʱ")>=0){
									ExtTool.alert("��ʾ","1�����ɹ����޲�����������Ƭ�޲�������2����״�ټ���������3�����ټ���������4���ؽھ����������5����������Ĥ����������6��­�������г�������7����Ѫ��;�������������  ԭ���ϲ���ʹ�ÿ���ҩ�� ");
									}	
								if((R.data.desc.indexOf("����(����70��)������ȱ����")>=0)||R.data.desc.indexOf("������ֲ����")>=0){
									ExtTool.alert("��ʾ","I���п�����Ԥ��ʹ�ÿ���ҩ��ʱ��ԭ���ϲ�����24Сʱ ");
									}
								}
							
							}
				}
		});
		this.AntIndicationsStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocAntibioticReason';
			param.QueryName = 'GetAntIndications';
			param.Arg1 = this.UserReason.getValue();
			param.ArgCnt=1;
		},this);
		//*********************************
		this.AntSSYFTimeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		this.AntSSYFTimeStore = new Ext.data.Store({
				proxy:this.AntSSYFTimeStoreProxy,
				reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
				,{name: 'Rowid', mapping: 'Rowid'}
			])
		});
		this.AntSSYFTime = new Ext.form.ComboBox({
			id :'AntSSYFTime'
			,minChars : 1
			,store : this.AntSSYFTimeStore
			,valueField : 'Rowid'
			,fieldLabel : "Ԥ����ҩʱ��&nbsp;",
			allowBlank:true,
			emptyText:"��ѡ��Ԥ����ҩʱ��"
			,displayField : 'desc'
			,width:200
			,triggerAction : 'all',
			editable:false,
			disabled:true
		});
		this.AntSSYFTimeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocAntibioticReason';
			param.QueryName = 'QrySSYFTime';
			//param.Arg1 =0    //this.UserReason.getValue();
			param.ArgCnt=0;
		},this);
		this.Submission=new Ext.form.ComboBox({
				id:'Submission',
				fieldLabel:"��ԭѧ�ͼ�<font color='red'>*</font>",
				allowBlank:false,
				mode:'local',
				store:new Ext.data.ArrayStore({
						fields:['SubmissCode','SubmissDesc'],
						data:[['N','No'],['Y','Yes']]
				}),
				displayField:'SubmissDesc',
				valueField:'SubmissCode',
				value:'N',
				width:200,
				editable:false,
				triggerAction : 'all'
					
		});
		var comboboxSubmission=this.Submission;
		this.AntBodyPartStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		this.AntBodyPartStore = new Ext.data.Store({
				proxy:this.AntBodyPartStoreProxy,
				reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
				,{name: 'Rowid', mapping: 'Rowid'}
			])
		});
		this.AntBodyPart = new Ext.form.ComboBox({
			id :'AntBodyPart'
			,minChars : 1
			,store : this.AntBodyPartStore
			,valueField : 'Rowid'
			,fieldLabel : "��Ⱦ��λ<font color='red'>*</font>",
			allowBlank:false,
			emptyText:"��ѡ���Ⱦ��λ"
			,displayField : 'desc'
			,width:200
			//,anchor : '99%'
			,triggerAction : 'all',
			editable:false
		});
		this.AntBodyPartStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocAntibioticReason';
			param.QueryName = 'QryInfPosition';
			param.Arg1 = 1;  //this.UserReason.getRawValue();
			param.ArgCnt=1;
		},this);
		this.AntSusceptStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		//ҩ����¼rowid^���^��������^������^^����^ϸ����[����]^��ҩ����^ϸ����Ӣ����^��������^��ע   ���
		//Rowid   SeqNo   ReportDate   SampleNo  SpecResource   code  BacterialNameC  Resistance  BacterialNameE  AntName   Note
		//ҩ����¼ rowid^��ԭ��^ ����ҩ��^ ��ҩ����^ �ͼ���Ŀ^ �걾^ �ͼ�����^ �������
		this.AntSusceptStore=new Ext.data.Store({
				proxy:this.AntSusceptStoreProxy,
				reader:new Ext.data.JsonReader({
						root:'record',
						totalProperty:'total',
						idProperty:'Rowid'
						},
						[
								{name:'checked',mapping:'checked'},
								{name:'SeqNo',mapping:'SeqNo'},
								{name:'ReportDate',mapping:'ReportDate'},
								{name:'SampleNo',mapping:'SampleNo'},
								{name:'SpecResource',mapping:'SpecResource'},
								{name:'code',mapping:'code'},
								{name:'BacterialNameC',mapping:'BacterialNameC'},
								{name:'Resistance',mapping:'Resistance'},
								{name:'BacterialNameE',mapping:'BacterialNameE'},
								{name:'AntName',mapping:'AntName'},
								{name:'Note',mapping:'Note'},
								{name:'Rowid',mapping:'Rowid'},
								{name:'TSName',mapping:'TSName'},
								{name:'BiaoBName',mapping:'SPName'},
								{name:'RecDate',mapping:'RecDate'}
						])	
		});
		this.sm=new Ext.grid.CheckboxSelectionModel({chekcOnly:true});
		this.AntSuscept=new Ext.grid.GridPanel({
				id:'AntSuscept',
				store:this.AntSusceptStore,
				iconCls:"c-sensitive-icon",
				title:'ҩ�����',
				viewConfig: {
					forceFit: true
					},
				//hideHeaders:true,
				height:100,
				sm:this.sm,
				listeners:{    
		       rowclick : function(grid, rowIndex, e){  
		            var SusceptSelModel=grid.getSelectionModel();
								if(SusceptSelModel.isSelected(rowIndex)){
								      	comboboxSubmission.setValue("Y");
								      	comboboxSubmission.setRawValue("Yes")
									}
				        }  
				    }, 
				columns:[
						this.sm,
						{header:'���',dataIndex:'SeqNo',width:70,sortable: true},
						{header:'ϸ����(����)',dataIndex:'BacterialNameC',sortable: true},
						{header:'��������',dataIndex:'AntName',sortable: true},
						{header:'��ҩ����',dataIndex:'Resistance',sortable: true},
						{header:'������Ŀ',dataIndex:'TSName',width:160,sortable: true},
						{header:'�걾',dataIndex:'BiaoBName',sortable: true},
						{header:'��������',dataIndex:'RecDate',sortable: true},
						{header:'��������',dataIndex:'ReportDate',sortable: true},
						{header:'������',dataIndex:'SampleNo',sortable: true,hidden:true},
						{header:'�걾��Դ',dataIndex:'SpecResource',sortable: true,hidden:true},
						{header:'����',dataIndex:'code',sortable: true,hidden:true},
						{header:'ϸ����(Ӣ)',dataIndex:'BacterialNameE',sortable: true,hidden:true},
						{header:'��ע',dataIndex:'Note',sortable: true,hidden:true},
						{header:'Rowid',dataIndex:'Rowid',sortable: true,hidden:true}
				]
		});
		
		this.AntSusceptStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocAntibioticApply';
			param.QueryName = 'GetOrderSuscept';
			param.Arg1 = this.EpisodeID
			param.ArgCnt=1;
	  },this);
	  this.AntOperationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		//������¼   ����rowid^��������^������ʼʱ��^��������ʱ��^��������   
		//OperationRowid^OperationDesc^OperationStartDate^OperationEndDate^OperationLoc
		this.AntOperationStore=new Ext.data.Store({
				proxy:this.AntOperationStoreProxy,
				reader:new Ext.data.JsonReader({
						root:'record',
						totalProperty:'total',
						idProperty:'Rowid'
						},
						[
								{name:'checked',mapping:'checked'},
								{name:'OperationRowid',mapping:'OpaId'},
								{name:'OperationDesc',mapping:'OpName'},
								{name:'opeSDate',mapping:'opeSDate'},
								{name:'opeSTime',mapping:'opeSTime'},
								{name:'opeEDate',mapping:'opeEDate'},
								{name:'opeETime',mapping:'opeETime'},
								{name:'OperationLoc',mapping:'OperLocDesc'}
						])	
		});
		this.sm1=new Ext.grid.CheckboxSelectionModel();
		this.AntOperation=new Ext.grid.GridPanel({
				id:'AntOperation',
				title:'��         ��',
				store:this.AntOperationStore,
				viewConfig: {forceFit: true},
				iconCls:"c-sensitive-icon",
				//hideHeaders:true,
				height:100,
				listeners:{    
		        rowclick : function(grid, rowIndex, e){  
		        		var UserReason=Ext.getCmp('UserReason').getRawValue()
		        		if(!UserReason){
		        				alert("������дʹ��Ŀ�ģ�ָ������Ϣ��")
		        				grid.getSelectionModel().clearSelections();
		        				return;
		        			}
		            var AntOperationSelModel=grid.getSelectionModel();
		            			//alert(Opflag);
								if(AntOperationSelModel.isSelected(rowIndex)){
										if(Opflag){
								      AntOperationSelModel.deselectRow(rowIndex);
								      Opflag=false;
								      }else{
								      	//var UserReasonDesc=Ext.getCmp('UserReason').getRawValue()
												var OperationID=grid.getSelectionModel().getSelected().get("OperationRowid")                        
												if(UserReason.indexOf("Ԥ��")>=0){
												var OrderFlagTime=tkMakeServerCall("web.DHCDocAntiCommon","ContrOPOrde",EpisodeID,OperationID,ArcimRowid);
												if(OrderFlagTime==1){
													alert("�������ڡ�Ԥ��-������ʹ��Ŀ���£��������ô�ҩ!");
													grid.getSelectionModel().clearSelections();
													Opflag=false;
													}
												}else{
													Opflag=true;
												}
								      	
								      }
									}
				        }  
				    }, 
				columns:[
						this.sm1,
						{header:'��������',dataIndex:'OperationDesc',sortable: true},
						{header:'������ʼ����',dataIndex:'opeSDate',sortable: true},
						{header:'������ʼʱ��',dataIndex:'opeSTime',sortable: true},
						{header:'������������',dataIndex:'opeEDate',sortable: true},
						{header:'��������ʱ��',dataIndex:'opeETime',sortable: true},
						{header:'��������',dataIndex:'OperationLoc',sortable: true},
						{header:'Rowid',dataIndex:'OperationRowid',sortable:true,hidden:true}
				]
		});
		this.AntOperationStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocAntibioticReason';
			param.QueryName = 'GetOperations';
			param.Arg1 = this.EpisodeID
			param.ArgCnt=1;
	  },this);
	  
	  AntReasonPan.superclass.constructor.call(this,{
					id:'AntReasonPan',
					title:'1-ʹ��Ŀ��',
					layout:'form',
					iconCls:'c-useaim-icon',
					buttonAlign : 'center',
					labelAlign:"right",
					frame:true,
					labelWidth:100,
					items:[
							{
								layout:'column',
								
								items:[
										{
												columnWidth:.55,
												layout:'form',
												labelSeparator:'&nbsp',
												items:[
														this.UserReason,
														this.AntBodyPart,
														this.CauseAna	
												]
										},{
												columnWidth:.45,
												layout:'form',
												labelSeparator:'&nbsp',
												items:[
														this.Submission,
														this.AntIndications,
														this.AntSSYFTime 
												]
										}
								]
							}
							,this.AntSuscept
							,this.AntOperation
					]
		});
		////this.LoadData()    //by wuqk 2012-11-05
		this.AntSusceptStore.load({callback:function(){
				var SusceptItems=this.AntSuscept.getStore().data.items
						var len=SusceptItems.length;
						if (len>0){
							comboboxSubmission.setValue("Y");
							comboboxSubmission.setRawValue("Yes");
							}
						for(var i=0;i<len;i++){
							var record=SusceptItems[i].data
								//alert("record['Rowid']="+record['Rowid'])
								if(this.SusceptValue==record['Rowid']){
										var SusceptSelModel=this.AntSuscept.getSelectionModel()
										SusceptSelModel.selectRow(i)
										this.AntSuscept.getView().focusRow(0)
										//break;
								}
						}
		},scope:this
		});

		this.AntOperationStore.load({});
		this.UserReason.on('select',this.SelectUserReason,this)
		this.UserReasonStore.load({callback:function(r,options,success){
					if(this.UserReasonValue!=""){
							this.UserReason.setValue(this.UserReasonValue)
								this.ownerCt.ownerCt.UserReasonDesc=this.UserReason.getRawValue();
								if(this.ownerCt.ownerCt.ShowTabStr.indexOf("Apply")>=0){
									//this.ownerCt.ownerCt.AntApplyPan.OrderAntReason.setValue(this.ownerCt.ownerCt.UserReasonDesc)
								}
							this.AntIndicationsStore.load({callback:function(r,options,success){
									if(this.AntIndicationsValue!=""){
											this.AntIndications.setValue(this.AntIndicationsValue)	
									}			
							},scope:this
							});
					}
					
		},scope:this	
		});
		this.AntBodyPartStore.load({callback:function(r,options,success){
				if(this.AntBodyPartValue!=""){
						this.AntBodyPart.setValue(this.AntBodyPartValue)
						this.ownerCt.ownerCt.AntBodyPartDesc=this.AntBodyPart.getRawValue();
						//this.ownerCt.ownerCt.AntApplyPan.OrderPart.setValue(this.ownerCt.ownerCt.AntBodyPartDesc)
				}	
		},scope:this
		});
		var task = new Ext.util.DelayedTask(function() {
						var SusceptItems=this.AntSuscept.getStore().data.items
						var len=SusceptItems.length;
						for(var i=0;i<len;i++){
							var record=SusceptItems[i].data
								//alert("record['Rowid']="+record['Rowid'])
								if(this.SusceptValue==record['Rowid']){
										var SusceptSelModel=this.AntSuscept.getSelectionModel()
										SusceptSelModel.selectRow(i)
										this.AntSuscept.getView().focusRow(0)
										break;
								}
						}
						var  OperationItems=this.AntOperation.getStore().data.items
						var len1=OperationItems.length;
						for(var i=0;i<len1;i++){
								var record=	OperationItems[i].data
								if(this.AntOperationValue==record['OperationRowid']){
										var AntOperationSelModel=this.AntOperation.getSelectionModel()	
										AntOperationSelModel.selectRow(i)
										this.AntOperation.getView().focusRow(i)
										break;
								}
						}
			
		},this);
		
		task.delay(2500);

}
Ext.extend(AntReasonPan,Ext.FormPanel,{
		CheckBeforeUpdate:function(){
			//У�����ݣ�������ϸ񣬷���false�����򷵻�true

			var UserReasonValue=this.UserReason.getValue();  //ʹ��Ŀ�� 
			if(UserReasonValue==""){
					ExtTool.alert("��ʾ","ʹ��Ŀ�Ĳ���Ϊ��!");
					return	;
			}
			var AntBodyPart=this.AntBodyPart.getValue();   //��Ⱦ��λ
			var TabStr=this.ownerCt.ownerCt.ShowTabStr
			if(AntBodyPart==""){
					ExtTool.alert("��ʾ","��Ⱦ��λ����Ϊ��!");
					return;
			}
			var AntSusceptNum=this.AntSuscept.getSelectionModel().getCount()
			var UserReasonDesc=this.UserReason.getRawValue()
			if((UserReasonDesc.indexOf("ҩ��")>=0)&&(AntSusceptNum==0)){
					ExtTool.alert("��ʾ","��ѡ��ҩ����¼!");
					return ;
			}
			var OperationNum=this.AntOperation.getSelectionModel().getCount()
			if((UserReasonDesc.indexOf("Ԥ��-����")>=0)&&(OperationNum==0)){
					ExtTool.alert("��ʾ","��ѡ��������¼!");	
					return ;
			}
			if ((AntSusceptNum==0)&&(UserReasonDesc.indexOf("����")>=0)&&(this.Submission.getValue()=="N")){
					//ExtTool.alert("��ʾ","�뽫��ҩƷ�ͼ죡!");
					//return;
			}
			if ((UserReasonDesc.indexOf("Ԥ��-����")>=0)&&(this.AntSSYFTime.getValue()=="")){
					ExtTool.alert("��ʾ","��ѡ��Ԥ����ҩʹ��ʱ�䣡");  // add by qp 2014-04-21
					return;
			}
			var AntIndications=this.AntIndications.getValue()    //ָ��
			if(AntIndications==""){
					ExtTool.alert("��ʾ","ָ������Ϊ��!");
					return;	
			}
			return true;	
		},
		GetReason:function(){	
			//��֯���� 
			var ReasonInfo="";
				var AntSuscept=""
				this.AntSusceptNum=this.AntSuscept.getSelectionModel().getCount()
				if(this.AntSusceptNum>0){
						var arrlist = this.sm.getSelections();
					 	for (var rowIndex=0;rowIndex<arrlist.length;rowIndex++){
								var r = arrlist[rowIndex];
								AntSuscept=r.data.Rowid+"&"+AntSuscept
						}
						//AntSuscept=this.AntSuscept.getSelectionModel().getSelected().get("Rowid")   //ҩ�����
				}
				var AntOperation=""
				this.OperationNum=this.AntOperation.getSelectionModel().getCount()
				if(this.OperationNum>0){
						AntOperation=this.AntOperation.getSelectionModel().getSelected().get("OperationRowid")   //������¼
				} 
				var UserReasonDesc=this.UserReason.getRawValue()
				
				var CauseAna=this.CauseAna.getValue();    //ԭ�����
				var AntIndications=this.AntIndications.getValue()    //ָ��
				var Submission=this.Submission.getValue()     //�����ͼ�
				var AntOtherReason="" ;  //this.AntOtherReason.getValue();    //��������
				var AntConscommt="" ;  //this.AntConscommt.getValue();        //ר�һ������   ���ֶ�Ϊ��
				var UserReasonId=this.UserReasonId
				var UserReasonValue=this.UserReason.getValue(); 
				var AntBodyPart=this.AntBodyPart.getValue(); 
				var SSYFTime=this.AntSSYFTime.getValue()	
				var Para=UserReasonId+"^"+UserReasonValue+"^"+CauseAna+"^"+AntIndications+"^"+Submission+"^"+AntBodyPart+"^"+AntSuscept
				Para=Para+"^"+AntOperation+"^"+AntOtherReason+"^"+AntConscommt+"^"+session['LOGON.USERID']+"^"+this.ArcimRowid+"^"+this.EpisodeID+"^"+SSYFTime    //+"^"+this.SeqNoValue.getValue()
				return Para;
		},CancelAntReason:function(){
				//ownerCt��øö�����ϼ�����
 				this.ownerCt.ownerCt.close()	
		},SelectUserReason:function(){
				this.AntIndications.setValue("")
				this.AntIndications.setRawValue("")
				this.AntIndicationsStore.load({});	
		},LoadData:function(){
				var ReasonObj=ExtTool.StaticServerObject("web.DHCDocAntibioticReason");
				var ReasonDataStr=ReasonObj.GetAntReasonData(this.EpisodeID,this.ArcimRowid,this.UserReasonId)
				var ReasonArr=ReasonDataStr.split("!")
				var ArcimDescStr=ReasonArr[0]
				var ArcimDescArr=ArcimDescStr.split("^")
				this.OrderNameValue.setValue(ArcimDescArr[0])
				this.SeqNoValue.setValue(ArcimDescArr[1])
				var ReasonData=ReasonArr[1]
				if(ReasonData!=""){
						var ReasonDataArr=ReasonData.split("^")
						this.UserReasonValue=ReasonDataArr[0]	
						this.CauseAna.setValue(ReasonDataArr[1])
						this.AntIndicationsValue=ReasonDataArr[2]
						this.Submission.setValue(ReasonDataArr[3])
						this.AntBodyPartValue=ReasonDataArr[4]
						this.AntOtherReason.setValue(ReasonDataArr[7])
						this.AntConscommt.setValue(ReasonDataArr[8])
						this.SusceptValue=ReasonDataArr[5]
						this.AntOperationValue=ReasonDataArr[6]
						//var items=obj.DeptPathGrid.getStore().data.items;
						
				}
		}
})
Ext.reg('AntReasonPan',AntReasonPan)

/*!
 * ��д����:2012-07-23
 * ���ߡG�����tion
 * ˵���G����ҩ�������ĵǼǱ�ı������
 * ���ơGAntMain.js
 */
AntApplyPan=function(EpisodeID,ArcimRowid,AntibApplyRowid,OrderPoisonCode,ShowTabStr){
		//סԺ����ʾ��
		this.EpisodeID=EpisodeID
		this.ArcimRowid=ArcimRowid
		this.AntibApplyRowid=AntibApplyRowid
		this.UserAdd="";
		this.UserAddName=""
		this.OrderInsValue=""
		this.AdmExcLocValue=""
		this.AdmExcDocValue=""
		this.OrderInsDesc=""
		this.OrderPoisonCode=OrderPoisonCode
		
		this.OrderInsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		
		this.OrderInsStore = new Ext.data.Store({
				proxy: this.OrderInsStoreProxy,
				reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
				,{name: 'Rowid', mapping: 'Rowid'}
			])
		});
		//20130201
		/*this.OrderPriNORM=new Ext.form.Checkbox({
			id :'OrderPriNORM'
			,store : this.OrderPriNORM
			,valueField : 'OrderPriNORM'
			,fieldLabel : "��ʱҽ��<font color='red'></font>"
			//,width:30
			,listeners:{
						check:function(box,e){
							if((e==true)&&(ShowTabStr.indexOf("Consult")>=0)){
								Ext.getCmp('isEmergency').enable();
								}else{
									if (typeof(Ext.getCmp('isEmergency'))!="undefined"){
										Ext.getCmp('isEmergency').setValue(false);
										Ext.getCmp('isEmergency').disable();
										}
									}
							}
				}
			});*/
		this.isEmergency=new Ext.form.Checkbox({
			id :'isEmergency'
			,store : this.isEmergency
			,valueField : 'isEmergency'
			,fieldLabel : "�Ƿ�Խ��ʹ��"
			//,width:30
			});
		this.OrderIns = new Ext.form.ComboBox({
			id :'OrderIns'
			,minChars : 1
			,store : this.OrderInsStore
			,valueField : 'Rowid'
			,fieldLabel : "�÷�<font color='red'>*</font>",
			allowBlank:false,
			emptyText:"��ѡ���÷�"
			,displayField : 'desc'
			,triggerAction : 'all'
			//,width:120
			,valueNotFoundText:''     //20140106
			,anchor : '99%'
		});
		this.OrderInsStoreProxy.on('beforeload', function(objProxy, param){
		
			param.ClassName = 'web.DHCDocOrderCommon';
			param.QueryName = 'GetInstr';
			param.Arg1 = this.OrderIns.getRawValue();
			param.ArgCnt=1;
		},this);
		this.OrderApplyDate=new Ext.form.DateField({
					id:'OrderApplyDate',
					fieldLabel:"��ʼ����<font color='red'>*</font>",
					allowBlank:false,
					validateOnBlur: false,
					//format:"Y-m-d",
					value:new Date()
					//altFormats : 'Y-m-d|d/m/Y'	
					//,width:60
					,anchor : '99%'
		});
		
		this.OrderDays=new Ext.form.NumberField({
					id:'OrderDays',
					fieldLabel:"Ԥ���Ƴ�(��)<font color='red'>*</font>",
					allowBlank:false,
					allowNegative:false,
					value:1,
					width : 20
		});
		
		AntApplyPan.superclass.constructor.call(this,{
					id:'AntReason',
					title:'2-������Ϣ',
					layout:'form',
					iconCls:"c-apply-icon",
					buttonAlign : 'center',
					labelAlign:"right",
					frame:true,
					labelWidth:40,
					items:[
							{
								layout:'column',
								items:[
												{
													columnWidth:.18,
													layout:'form',
													labelSeparator:'&nbsp',
													items:[
															this.isEmergency     
													]
											},{
												columnWidth:.35,
												layout:'form',
												labelSeparator:'&nbsp',
												items:[
													this.OrderIns
												]	
											},{
												columnWidth:.27,
												layout:'form',
												labelSeparator:'&nbsp',
												items:[
													this.OrderApplyDate
												]	
											},{
													columnWidth:.2,
													layout:'form',
													labelSeparator:'&nbsp',
													items:[
															this.OrderDays
													]
											}	
										]}
					]
		});
		this.OrderInsStore.load({callback:function(r,options,success){
					if(this.OrderInsValue!=""){
							this.OrderIns.setValue(this.OrderInsValue)
					}
					
		},scope:this	
		});
}
Ext.extend(AntApplyPan,Ext.Panel,{
			GetApplyInfo:function(UserReasonId){
					//��ȡ���뵥����Ϣ
					var ApplyInfo="";
	
					var EpisodeID=this.EpisodeID
					var ArcimRowid=this.ArcimRowid
					var OrderPriorRowid=""    //this.OrderPriNORM.getValue();
					if (OrderPriorRowid==true){
						OrderPriorRowid=1;
						}else{
							OrderPriorRowid="";
							}
					var DoseQty=""
					var OrderDoseUomRowid=""
					var OrderDurRowid=""
					var OrderFreqRowid=""
					var ApplyUserID=session['LOGON.USERID'];
					var ApplyDate=this.OrderApplyDate.getRawValue();
					var ApplyTime=""
					var StopDate=""        //this.OrderStopDate.getRawValue();
					var StopTime=""
					var MicrobeSpec=""
					var DrugTest="N"
					var ApplyRemark=""
					var OrderDays=this.OrderDays.getRawValue();  //121108
					//if(this.UserAdd==""){
							this.UserAdd=session['LOGON.USERID']
					//}
					//var UserAdd=session['LOGON.USERID']
					var ApplyTypeControl="P"
					var UseReasonID=""            //this.ownerCt.ownerCt.UserReasonId
					var ConsultationDepRowID=""   //this.AdmExcLoc.getValue() 
					var ConsultationDocRowID=""   //this.AdmExcDoc.getValue();
					var OrderInsterRowID=this.OrderIns.getValue();      //�÷�
					var OrderInster=this.OrderIns.getRawValue();    
					var isEmergency=this.isEmergency.getValue()
					if(isEmergency==true){ isEmergency=1}
					else{isEmergency=0}

					var Para=EpisodeID+"^"+ArcimRowid+"^"+OrderPriorRowid+"^"+DoseQty+"^"+OrderDoseUomRowid+"^"+OrderFreqRowid;
					Para=Para+"^"+OrderDurRowid+"^"+OrderInsterRowID+"^"+ApplyUserID+"^"+ApplyDate+"^"+ApplyTime+"^"+ApplyRemark;
					Para=Para+"^"+StopDate+"^"+StopTime+"^"+UseReasonID+"^"+MicrobeSpec+"^"+DrugTest+"^"+ConsultationDepRowID;
					Para=Para+"^"+ConsultationDocRowID+"^"+this.UserAdd+"^"+ApplyTypeControl+"^"+this.AntibApplyRowid+"^"+UserReasonId;
					Para=Para+"^"+OrderDays+"^"+isEmergency+"^"+session['LOGON.CTLOCID']
					return Para;
					
			},CancelApply:function(){
 				//ownerCt��øö�����ϼ�����
 				this.ownerCt.ownerCt.close()
 				
 		},CheckBeforeUpdate:function(){
	 			//У�����ݣ�������ϸ񣬷���false�����򷵻�true
					var OrderInsterRowID=this.OrderIns.getValue();
					var OrderInster=this.OrderIns.getRawValue();
					if ((OrderInsterRowID=="")||(OrderInster=="")){
							ExtTool.alert("��ʾ","�÷�����Ϊ��!");
							return false;
					}
					var ApplyDate=this.OrderApplyDate.getValue()
					if (ApplyDate==""){
							ExtTool.alert("��ʾ","��ʼ���ڲ���Ϊ��!");
							return false;
					}
					var OrderDays=this.OrderDays.getValue();
					if (OrderDays==""){
						ExtTool.alert("��ʾ","Ԥ���Ƴ̲���Ϊ��!");
						return false;
						}
					return true;
 		},GetPatDetail:function(){
 					//������Ϣ
 					var ApplyObj = ExtTool.StaticServerObject("web.DHCDocAntibioticApply");
					var PatDetail = ApplyObj.GetPatDetail(this.EpisodeID);
					var PatDetailArr=PatDetail.split("^");
					var PatientName=PatDetailArr[0];
					var PatientSex=PatDetailArr[1];
					var AgeDesc=PatDetailArr[2];
					var Medcare=PatDetailArr[3];
					var AdmDep=PatDetailArr[4];
					var AdmDoc=PatDetailArr[5];
					var Bed=PatDetailArr[24];
					var AdmDepID=PatDetailArr[7];
					var AdmDocID=PatDetailArr[8];
					this.PatientName.setValue(PatientName)
					this.InPatientNo.setValue(Medcare)
					this.PatientSex.setValue(PatientSex);
					this.PatientAge.setValue(AgeDesc)
					this.PatientAdmLoc.setValue(AdmDep)
					this.PatientBedNo.setValue(Bed)
					//ҩƷ��Ϣ
					var EPARCIMDetail=ApplyObj.GetEPARCIMDetail(this.EpisodeID,this.ArcimRowid)
					var TempArr=EPARCIMDetail.split("^");
					//ArcimDesc_"^"_DrgformRowid_"^"_FormDesc_"^"_FormInstrRowid_"^"_FormInstrDesc
					var ArcimDesc=TempArr[0];
					var DrgformRowid=TempArr[1];
					var FormDesc=TempArr[2];
					var FormInstrRowid=TempArr[3];
					var FormInstrDesc=TempArr[4];
					this.OrderName.setValue(ArcimDesc)
					this.OrderCat.setValue(FormDesc)
					var DefaultDateStr=ApplyObj.GetDefaultDate(this.EpisodeID)
					this.OrderApplyDate.setValue(DefaultDateStr.split("^")[0])
					this.OrderApplyDoc.setValue(session['LOGON.USERNAME'])
					//this.OrderAntReason.setValue(this.ownerCt.ownerCt.UserReasonDesc)
					//this.OrderPart.setValue(this.ownerCt.ownerCt.AntBodyPartDesc)
					//���뵥��Ϣ
					if(this.AntibApplyRowid!=""){
							//�������뵥��Ϣ
							var OrderAntApplyInfo=ApplyObj.GetOrderAntApplyInfo(this.AntibApplyRowid)
							//alert(OrderAntApplyInfo)
							if(OrderAntApplyInfo!=""){
									AntArr=OrderAntApplyInfo.split("!")
									var ApplyDate=AntArr[0]
									var EndDate=AntArr[1]
									var DoctorName=AntArr[2]
									var ConsultationDep=AntArr[3]
									var ConsultationDoc=AntArr[4]
									var OrderInstrId=AntArr[6]
									this.OrderApplyDate.setRawValue(ApplyDate)
									this.OrderStopDate.setRawValue(EndDate)
									this.OrderApplyDoc.setValue(DoctorName)
									this.AdmExcLocValue=ConsultationDep
									this.AdmExcDocValue=ConsultationDoc
									this.OrderInsValue=OrderInstrId
									//this.AdmExcDocStore.load({});
									//this.AdmExcDoc.setValue(ConsultationDoc)
									this.UserAdd=AntArr[5]
									
							}
					}
 			}
})
Ext.reg('AntApplyPan',AntApplyPan)



/*
*  �������������Ϣ
*/
AntConsultation=function(EpisodeID,ArcimRowid,AntibApplyRowid,OrderPoisonCode){
		//סԺ����ʾ��
		this.EpisodeID=EpisodeID
		this.ArcimRowid=ArcimRowid
		this.AntibApplyRowid=AntibApplyRowid
		this.AdmExcLocValue=""
		this.AdmExcDocValue=""
		this.OrderPoisonCode=OrderPoisonCode
		
	
		this.AdmExcLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		this.AdmExcLocStore = new Ext.data.Store({
				proxy: this.AdmExcLocStoreProxy,
				reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
				,{name: 'Rowid', mapping: 'Rowid'}
			])
		});
		this.AdmExcLoc = new Ext.form.ComboBox({
			id :'AdmExcLoc'
			,minChars : 1
			,store : this.AdmExcLocStore
			,valueField : 'Rowid'
			,fieldLabel : "�������<font color='red'>*</font>",
			allowBlank:false,
			mode:'local',
			width:200,
			emptyText:"��ѡ�����"
			,displayField : 'desc'
			,triggerAction : 'all'
			,listeners:{
				select:function(x,y,curindex){
					Ext.getCmp('AdmExcDoc').setRawValue("")
					Ext.getCmp('AdmExcDoc').setValue("")
					}
				}
		});
		this.AdmExcLocStoreProxy.on('beforeload', function(objProxy, param){
			//param.ClassName = 'web.DHCDocAntibioticApply';
			//param.QueryName = 'GetExecuteLoc';
			param.ClassName = 'web.DHCDocAntiCommon';
			param.QueryName = 'GetConsultLoc';
			param.Arg1 = this.AdmExcLoc.getRawValue();
			param.ArgCnt=1;
	  },this);
	  
	this.AdmExcDocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		this.AdmExcDocStore = new Ext.data.Store({
				proxy: this.AdmExcDocStoreProxy,
				reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
				,{name: 'Rowid', mapping: 'Rowid'}
			])
		});
		this.AdmExcDoc = new Ext.form.ComboBox({
			id :'AdmExcDoc'
			,minChars : 1
			,store : this.AdmExcDocStore
			,valueField : 'Rowid'
			,fieldLabel : "����ҽ��<font color='red'>*</font>",
			allowBlank:false,
			width:200,
			emptyText:"��ѡ��ҽ��"
			,displayField : 'desc'
			,triggerAction : 'all'
			,editable:false
		});
		this.AdmExcDocStoreProxy.on('beforeload', function(objProxy, param){
			//param.ClassName = 'web.DHCDocAntibioticApply';
			//param.QueryName = 'GetExecuteDoc';
			param.ClassName = 'web.DHCDocAntiCommon';
			param.QueryName = 'GetConsultDoc';
			param.Arg1 = this.AdmExcLoc.getValue();
			param.ArgCnt=1;
	  },this);
	  
	  
		//this.OrderSusceptStore.load({});
		this.AdmExcLocStore.load({callback:function(r,options,success){
					if(this.AdmExcLocValue!=""){
							this.AdmExcLoc.setValue(this.AdmExcLocValue)
							this.AdmExcDocStore.load({callback:function(r,options,success){
					if((this.AdmExcDocValue!="")&&(this.AdmExcLocValue!="")){
								this.AdmExcDoc.setValue(this.AdmExcDocValue)
					}
		},scope:this});
					}
					
		},scope:this});
		this.AdmExcLoc.on('select',this.SelectDept,this)
		
		AntConsultation.superclass.constructor.call(this,{
					id:'AntConsultation',
					title:'3-��������',
					layout:'form',
					iconCls:"c-consult-icon",
					buttonAlign : 'center',
					labelAlign:"right",
					frame:true,
					//labelWidth:60,
					items:[
							{
								layout:'column',
								items:[{
												columnWidth:.5,
												layout:'form',
												labelSeparator:'&nbsp',
												items:[
													this.AdmExcLoc
												]	
											},{
												columnWidth:.5,
												layout:'form',
												labelSeparator:'&nbsp',
												items:[
													this.AdmExcDoc
												]	
											}
										]}
					]
		});
}
Ext.extend(AntConsultation,Ext.Panel,{
			GetConsultation:function(UserReasonId){
					//���������Ϣ 
					var Consultation="";
					//��ȡ���뵥����Ϣ
					
					var EpisodeID=this.EpisodeID
					var ArcimRowid=this.ArcimRowid
					var OrderPriorRowid=""                     //this.OrderPriNORM.getRawValue();
					var DoseQty=""
					var OrderDoseUomRowid=""
					var OrderDurRowid=""
					var OrderFreqRowid=""
					var ApplyUserID=session['LOGON.USERID'];
					var ApplyDate=""    //this.OrderApplyDate.getRawValue();
					var ApplyTime=""
					var StopDate=""            //this.OrderStopDate.getRawValue();
					var StopTime=""
					var MicrobeSpec=""
					var DrugTest="N"
					var ApplyRemark=""
					var OrderDays=""

					this.UserAdd=session['LOGON.USERID']
					var ApplyTypeControl="P"              //ֱ�������ʱ���Ƿ�Ҫ��״̬��
					var UseReasonID=""           //this.ownerCt.ownerCt.UserReasonId
					var ConsultationDepRowID=this.AdmExcLoc.getValue() 
					var ConsultationDocRowID=this.AdmExcDoc.getValue();
					
					var OrderInsterRowID=""   //this.OrderIns.getValue();      //�÷�
					var OrderInster=""      //this.OrderIns.getRawValue();    
					var isEmergency=0
					var Consultation=EpisodeID+"^"+ArcimRowid+"^"+OrderPriorRowid+"^"+DoseQty+"^"+OrderDoseUomRowid+"^"+OrderFreqRowid;
					Consultation=Consultation+"^"+OrderDurRowid+"^"+OrderInsterRowID+"^"+ApplyUserID+"^"+ApplyDate+"^"+ApplyTime+"^"+ApplyRemark;
					Consultation=Consultation+"^"+StopDate+"^"+StopTime+"^"+UseReasonID+"^"+MicrobeSpec+"^"+DrugTest+"^"+ConsultationDepRowID;
					Consultation=Consultation+"^"+ConsultationDocRowID+"^"+this.UserAdd+"^"+ApplyTypeControl+"^"+this.AntibApplyRowid+"^"+UserReasonId;
					Consultation=Consultation+"^"+OrderDays+"^"+isEmergency+"^"+session['LOGON.CTLOCID']
					return Consultation;
			},
			SelectDept:function(){
  				this.AdmExcDocStore.load({});	
 			},CancelApply:function(){
 				//ownerCt��øö�����ϼ�����
 				this.ownerCt.ownerCt.close()
 				
 		},CheckBeforeUpdate:function(){
	 			//У�����ݣ�������ϸ񣬷���false�����򷵻�true
	 			
					var ConsultationDepRowID=this.AdmExcLoc.getValue()
					if((ConsultationDepRowID=="")&&(this.OrderPoisonCode=="KSS3")){
							ExtTool.alert("��ʾ","������Ҳ���Ϊ��!");	
							return false;	
					}
					var ConsultationDocRowID=this.AdmExcDoc.getValue();
					if((ConsultationDocRowID=="")&&(this.OrderPoisonCode=="KSS3")){
							ExtTool.alert("��ʾ","����ҽ������Ϊ��!");	
							return false;	
					}
					return true;
 		}
})

AuditInfo=function(EpisodeID,userid){
		var flag=false;
    var AnditArcArr=""
		this.EpisodeID=EpisodeID;
		this.userid=userid;
		var btnSave = new Ext.Button({
				id : 'btnSave'
				,text : 'ȷ��'
				,iconCls:"c-btn-save"
				,scope:this
				,handler: function(){
					var AnditAARowidArr="";
					var AuditItems=this.auditApplyInfo.getStore().data
					
					
					/*for (var i=0;i<AuditItems.length;i++){
						var record=this.auditApplyInfo.getStore().getAt(i).data
						if(this.auditApplyInfo.getSelectionModel().isSelected(i)==true){
						//(record.get("StatusCode")=="U")&&(record.get("CheckBoxOk")==1)
							if(AnditAARowidArr==""){
								AnditAARowidArr=record.Rowid;
								}else{
									AnditAARowidArr=AnditAARowidArr+"^"+record.Rowid;
									}
							}
						}
						*/
						
					 var arrList = this.AuditInfoSM.getSelections();
					 for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
								var r = arrList[rowIndex];
								AnditAARowidArr=r.data.Rowid+"^"+AnditAARowidArr
					}
								
					var InsertObj=ExtTool.StaticServerObject("web.DHCDocAntibioticReason");
					var ret=InsertObj.GetAddToListArcimInfoNew('','',EpisodeID,AnditAARowidArr);
	  		  		window.returnValue= ret  
	  		  		window.close() 	
					//var ret=cspRunServerMethod(GlobalObj.AddAuditItemToListMethod,'AddCopyItemToList','',EpisodeID,AnditAARowidArr);
	  		  //Ext.getCmp('AuditAnt').close();     
	  		  //winAuditInfo.close();     
	  		}
		});
		var btnCancel=new Ext.Button({
				id:'btnCancel',
				text:'ȡ��',
				iconCls:"c-btn-cancel",
				scope:this,
				handler:function(){ 
						window.returnValue= ""  
	  		  			window.close()
						//winAuditInfo.close();  
						//Ext.getCmp('AuditAnt').close();
				}
		});
		this.auditApplyInfoProxy= new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		this.auditApplyInfoStore=new Ext.data.Store({
				proxy:this.auditApplyInfoProxy,
				reader:new Ext.data.JsonReader({
						root:'record',
						totalProperty:'total'
						//idProperty:'Rowid'
						},
						
						[
								{name:'SeqNo',mapping:'SeqNo'},
								{name:'ArcimName',mapping:'ArcimName'},
								{name:'Status',mapping:'Status'},
								{name:'AppUser',mapping:'AppUser'},
								{name:'AppDate1',mapping:'AppDate1'},
								{name:'AppTime1',mapping:'AppTime1'},
								{name:'Rowid',mapping:'Rowid'},
								{name:'StatusCode',mapping:'AppStatus'},
								{name:'AuditDoc',mapping:'AuditDoc'},
								{name:'AuditDate1',mapping:'AuditDate1'},
								{name:'AuditTime',mapping:'AuditTime'},
								{name:'ConsultDoc',mapping:'ConsultDoc'},
								{name:'ConsultDate',mapping:'ConsultDate'},
								{name:'CheckBoxOk',mapping:'CheckBoxOk'}
										
						])
			})
			
		this.auditApplyInfoProxy.on('beforeload',function(objProxy,param){
				param.ClassName = 'web.DHCDocAntibioticReason';
				param.QueryName = 'QryAntiAuditInfo';
				param.Arg1 = this.EpisodeID
				param.Arg2 = this.userid
				param.ArgCnt=2;
		},this);
		
	
	  this.AuditInfoSM = new Ext.grid.CheckboxSelectionModel({chekcOnly:true,
	  	renderer : function(v,m,record,r,c,s){
										if ((record.get("StatusCode")=="U")&&(record.get("CheckBoxOk")==1)){
											return '<div class="x-grid3-row-checker">&#160;</div>';
										}
									},
			listeners:{
					beforerowselect:function(t,i,b,r){
						if ((r.get("StatusCode")=="U")&&(r.get("CheckBoxOk")==1)){
								return true;
							}else{
								return false;
								}
					}
				}						
	  	});
	  ///
	  
	  
		//sm=new Ext.grid.CheckboxSelectionModel();
		this.auditApplyInfo=new Ext.grid.GridPanel({
				id:'auditApplyInfo',
				//sm:new Ext.grid.CheckboxSelectionModel(),
				sm : this.AuditInfoSM,
				store:this.auditApplyInfoStore,
				//title:'�������Ϣ',
				//viewConfig: {forceFit: true},
				listeners:{
					},
				//buttons:[btnSave,btnCancel],
				columns:[
						this.AuditInfoSM,
						{header:'���',dataIndex:'SeqNo',width:50},
						{header:'ҽ����',dataIndex:'ArcimName',width:180},
						{header:'���״̬',dataIndex:'Status'},
						{header:'������',dataIndex:'AppUser'},
						{header:'��������',dataIndex:'AppDate1'},
						{header:'����ʱ��',dataIndex:'AppTime1'},
						{header:'Rowid',dataIndex:'Rowid',hidden:true},
						{header:'StatusCode',dataIndex:'StatusCode',hidden:true},
						{header:'�����',dataIndex:'AuditDoc'},
						{header:'�������',dataIndex:'AuditDate1'},
						{header:'���ʱ��',dataIndex:'AuditTime'},
						{header:'����ҽ��',dataIndex:'ConsultDoc'},
						{header:'��������',dataIndex:'ConsultDate'},
						{header:'CheckBoxOk',dataIndex:'CheckBoxOk',hidden:true}
						//{ header: "", dataIndex: "B_Cancel", width: 50,
 						//	renderer: function (value, cellmeta) { return "<INPUT type='button' value='ɾ��'>";}
						//}
				]
			});
			
			
			/*
			*/
		var winAuditInfo = new Ext.Panel({
			height:420,
			iconCls:"c-useaim-icon",
			renderTo:Ext.getBody(),
			title:'����ҩ�������б�',
			layout:'fit',
			buttonAlign: 'center',
			items: this.auditApplyInfo,
			buttons:[btnSave,btnCancel]
		})
		this.auditApplyInfoStore.load();
}

GetKSSOrderStopInfo=function(){
		//debugger;
		//var EpisodeID=document.getElementById("EpisodeID").value;
		var EpisodeID=GlobalObj.EpisodeID
		var count=0;
		var btnSave = new Ext.Button({
				id : 'btnSave'
				,text : 'ȷ��',
				iconCls:"icon-save",
				scope:this,
				handler:function(){ 
					winGetOrderFlag.close();  
						//Ext.getCmp('AuditAnt').close();
				}
	
		});
		var btnCancel=new Ext.Button({
				id:'btnCancel',
				text:'ȡ��',
				iconCls:'icon-exit',
				scope:this,
				handler:function(){ 
						winGetOrderFlag.close();  
						//Ext.getCmp('AuditAnt').close();
				}
		});
		this.GetOrderFlagInfoProxy= new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		this.GetOrderFlagInfoStore=new Ext.data.Store({
				proxy:this.GetOrderFlagInfoProxy,
				reader:new Ext.data.JsonReader({
						root:'record',
						totalProperty:'total'
						//idProperty:'EpisodeID'
						},
						
						[
								{name:'EpisodeID',mapping:'EpisodeID'},
								{name:'PAPMIName',mapping:'PAPMIName'},
								{name:'ARCICDesc',mapping:'ARCICDesc'},
								{name:'ORSDate',mapping:'ORSDate'}
										
						])
			})
		
		this.GetOrderFlagInfoProxy.on('beforeload',function(objProxy,param){
				param.ClassName = 'web.DHCDocAntiCommon';
				param.QueryName = 'GetKSSOrderStopInfo';
				param.Arg1 = this.EpisodeID
				param.ArgCnt=1;
		},this);
		
		  ///
	  
	  
		//sm=new Ext.grid.CheckboxSelectionModel();
		this.GetOrderFlagInfo=new Ext.grid.GridPanel({
				id:'auditApplyInfo',
				//sm:new Ext.grid.CheckboxSelectionModel(),
				store:this.GetOrderFlagInfoStore,
				//title:'�������Ϣ',
				//viewConfig: {forceFit: true},
				columns:[
						{header:'�����',dataIndex:'EpisodeID',width:80},
						{header:'��������',dataIndex:'PAPMIName',width:100},
						{header:'ҩƷ��',dataIndex:'ARCICDesc',width:100},
						{header:'��ҽ��ʱ��',dataIndex:'ORSDate',width:102}
				]
			});
			
			
			/*
			*/
		var winGetOrderFlag=new Ext.Window({
				//id:'AuditAnt',
				height:200,
				width:400,
				title:'���¿���ҩ��ҽ���Ѿ�ʹ�ó���72Сʱ,�봦��',
				layout:'fit',
				closeAction:'close',
				resizable:false,
				closable:true,
				modal:true,
				items: this.GetOrderFlagInfo
				//buttons:[btnSave,btnCancel]
			})
			
			
			
			//this.GetOrderFlagInfoStore.load();
			this.GetOrderFlagInfoStore.load();
			this.GetOrderFlagInfoStore.addListener({load:function(store,records,options){
					if(records.length>0){
							winGetOrderFlag.show();
				}
			}})
			
			//count=this.GetOrderFlagInfoStore.getTotalCount();
			
				
			
}