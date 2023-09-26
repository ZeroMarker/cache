/*!
 * 编写日期:2012-07-23
 * V 1.0
 * 作者李宇峰
 * 说明抗菌药物管理
 * 名称AntMain.js
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
		// ****  添加会诊判断
		var LocID=session['LOGON.CTLOCID'];
		var NeedConsultOBJ=ExtTool.StaticServerObject("web.DHCDocAntiCommon");
		var NeedConsult=NeedConsultOBJ.IsNeedConsult(LocID)
		// ****  增加判断信息
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
		// ****  根据 Arcim 取药品信息
		var GetArcimObj=ExtTool.StaticServerObject("web.DHCDocAntibioticReason");
		var ArcimDetailStr=GetArcimObj.GetArcimDetailByArcim(this.ArcimRowid);
		var ArcimDetaiArr=ArcimDetailStr.split("^");
		this.Arcim=ArcimDetaiArr[0];
		this.Arcic=ArcimDetaiArr[1];
		this.Poison=ArcimDetaiArr[2];
		this.phDDD=ArcimDetaiArr[3];
		this.ArcimDesc=this.Arcim+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+this.Arcic+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+this.Poison+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"DDD:"+this.phDDD
	
		
		
		// ****  取医生的职称信息
		this.DoctorInfo=session['LOGON.USERNAME'] + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+this.CareType
		
		if (wantAudit){this.DoctorInfo+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"<font color='red'><B>需要审核</B></font>";}
		if (wantConsultation){this.DoctorInfo+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"<font color='red'><B>需要会诊</B></font>";}
		
		// **** SeqNoValue
		// **** 增加是否保存的标记
		//this.SaveFlag=false;
		
		this.baseInfo=new Ext.form.FieldSet({
		
		//this.baseInfo=new Ext.Panel({
			title: '基本信息',
			iconCls:"c-baseinfo-icon",
            collapsible: true,
            autoHeight:true,
            defaultType: 'label',
            items :[{
                    fieldLabel: '抗菌药物信息',
                    html: this.ArcimDesc    // 药物相关信息
                },{
                    fieldLabel: '医&nbsp;&nbsp;师&nbsp;&nbsp;信&nbsp;&nbsp;息&nbsp;',
                    html: this.DoctorInfo                 //  医师信息
                }]
              });
	  this.btnSave = new Ext.Button({
				id : 'btnSave'
				,text : '保存',
				iconCls:"c-btn-save",
				scope:this,
				handler: function(){
	  			this.SaveData()            
	  		}
		});
		this.btnCancel=new Ext.Button({
				id:'btnCancel',
				text:'取消',
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
				//title:'抗菌药物登记表',
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
					/*var flag=confirm("登记表未保存,是否继续退出?",true)
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
		//统一保存使用目的/申请信息/会诊申请，事务提交并关闭窗口
		
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
				alert("保存成功！");	
				SaveFlag=true;
				//this.close();
				window.close();
				return;
				}
			}else{
				alert("基本信息保存失败!");	
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
			//alert(""先完成会诊再审核。!");	
			}
		var ParaAll=AuditInfo+"&"+Consultation
		var InsertAllObj=ExtTool.StaticServerObject("web.DHCDocAntibioticReason");
		this.ReSult= InsertAllObj.InserAllInfo(ParaAll);
		var RsArr=this.ReSult.split("^")
		var Rs=RsArr[0]
		if (Rs==0){
			alert("保存成功！!");	
			SaveFlag=true;
			AntibApplyRowid=RsArr[1]
			//this.close();
			window.close();
			return;
			}else{
				alert("保存失败！!");	
				}
		
		//Save 
		//this.SaveFlag=true;
		//this.close();
		
	}
})
Ext.reg('mainAntWindow',AntMain)
//以上由使用目的弹出的窗口的主界面






/*!
 * 编写日期:2012-07-23
 * 作者李宇峰
 * 说明抗菌药物管理里的使用目的保存界面
 * 名称AntMain.js
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
			,fieldLabel : "使用目的<font color='red'>*</font>",
			allowBlank:false,
			emptyText:"请选择使用目的"
			,displayField : 'desc'
			,triggerAction : 'all',
			editable:false,
			width:200,
			//anchor : '99%',
			listeners:{
						select:function(x,R,curindex){
							if((R.data.desc.indexOf("预防-手术")>=0)){
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
				fieldLabel:'其它原因&nbsp;'
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
			,fieldLabel : "用药指征<font color='red'>*</font>",
			allowBlank:false,
			width:200,
			emptyText:"请选择指征"
			,displayField : 'desc'
			,triggerAction : 'all',
			editable:false,
			listeners:{
						select:function(x,R,curindex){
							if((R.data.desc.indexOf("其它")>=0)){
									alert("请填写其它原因!");
								}
							if(R.data.desc.indexOf("普通手术")>=0){
									ExtTool.alert("提示","1、腹股沟疝修补术（包括补片修补术）、2、甲状腺疾病手术、3、乳腺疾病手术、4、关节镜检查手术、5、颈动脉内膜剥脱手术、6、颅骨肿物切除手术、7、经血管途径介入诊断手术  原则上不予使用抗菌药物。其他I类切口手术预防使用抗菌药物时间原则上不超过24小时 ");
									}
							if(R.data.desc.indexOf("无切口")>=0){
									ExtTool.alert("提示","无切口手术不准使用抗生药物")
									x.setValue("")
									x.setRawValue("")
								}
							if(Ext.getCmp('UserReason').getRawValue().indexOf("清洁手术")>=0){
								//alert(1) delete by qp 2014-04-21
								if(R.data.desc.indexOf(">3小时")>=0){
									ExtTool.alert("提示","1、腹股沟疝修补术（包括补片修补术）、2、甲状腺疾病手术、3、乳腺疾病手术、4、关节镜检查手术、5、颈动脉内膜剥脱手术、6、颅骨肿物切除手术、7、经血管途径介入诊断手术  原则上不予使用抗菌药物 ");
									}	
								if((R.data.desc.indexOf("高龄(大于70岁)或免疫缺陷者")>=0)||R.data.desc.indexOf("器官移植手术")>=0){
									ExtTool.alert("提示","I类切口手术预防使用抗菌药物时间原则上不超过24小时 ");
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
			,fieldLabel : "预防用药时间&nbsp;",
			allowBlank:true,
			emptyText:"请选择预防用药时间"
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
				fieldLabel:"病原学送检<font color='red'>*</font>",
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
			,fieldLabel : "感染部位<font color='red'>*</font>",
			allowBlank:false,
			emptyText:"请选择感染部位"
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
		//药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注   最初
		//Rowid   SeqNo   ReportDate   SampleNo  SpecResource   code  BacterialNameC  Resistance  BacterialNameE  AntName   Note
		//药敏记录 rowid^病原体^ 抗菌药物^ 耐药机制^ 送检项目^ 标本^ 送检日期^ 审核日期
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
				title:'药敏结果',
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
						{header:'序号',dataIndex:'SeqNo',width:70,sortable: true},
						{header:'细菌名(中文)',dataIndex:'BacterialNameC',sortable: true},
						{header:'抗生素名',dataIndex:'AntName',sortable: true},
						{header:'耐药机制',dataIndex:'Resistance',sortable: true},
						{header:'检验项目',dataIndex:'TSName',width:160,sortable: true},
						{header:'标本',dataIndex:'BiaoBName',sortable: true},
						{header:'接收日期',dataIndex:'RecDate',sortable: true},
						{header:'报告日期',dataIndex:'ReportDate',sortable: true},
						{header:'样本号',dataIndex:'SampleNo',sortable: true,hidden:true},
						{header:'标本来源',dataIndex:'SpecResource',sortable: true,hidden:true},
						{header:'编码',dataIndex:'code',sortable: true,hidden:true},
						{header:'细菌名(英)',dataIndex:'BacterialNameE',sortable: true,hidden:true},
						{header:'备注',dataIndex:'Note',sortable: true,hidden:true},
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
		//手术记录   手术rowid^手术名称^手术开始时间^手术结束时间^手术科室   
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
				title:'手         术',
				store:this.AntOperationStore,
				viewConfig: {forceFit: true},
				iconCls:"c-sensitive-icon",
				//hideHeaders:true,
				height:100,
				listeners:{    
		        rowclick : function(grid, rowIndex, e){  
		        		var UserReason=Ext.getCmp('UserReason').getRawValue()
		        		if(!UserReason){
		        				alert("请先填写使用目的，指征等信息。")
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
												if(UserReason.indexOf("预防")>=0){
												var OrderFlagTime=tkMakeServerCall("web.DHCDocAntiCommon","ContrOPOrde",EpisodeID,OperationID,ArcimRowid);
												if(OrderFlagTime==1){
													alert("该手术在【预防-手术】使用目的下，不建议用此药!");
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
						{header:'手术名称',dataIndex:'OperationDesc',sortable: true},
						{header:'手术开始日期',dataIndex:'opeSDate',sortable: true},
						{header:'手术开始时间',dataIndex:'opeSTime',sortable: true},
						{header:'手术结束日期',dataIndex:'opeEDate',sortable: true},
						{header:'手术结束时间',dataIndex:'opeETime',sortable: true},
						{header:'手术科室',dataIndex:'OperationLoc',sortable: true},
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
					title:'1-使用目的',
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
			//校验数据，如果不合格，返回false，否则返回true

			var UserReasonValue=this.UserReason.getValue();  //使用目的 
			if(UserReasonValue==""){
					ExtTool.alert("提示","使用目的不能为空!");
					return	;
			}
			var AntBodyPart=this.AntBodyPart.getValue();   //感染部位
			var TabStr=this.ownerCt.ownerCt.ShowTabStr
			if(AntBodyPart==""){
					ExtTool.alert("提示","感染部位不能为空!");
					return;
			}
			var AntSusceptNum=this.AntSuscept.getSelectionModel().getCount()
			var UserReasonDesc=this.UserReason.getRawValue()
			if((UserReasonDesc.indexOf("药敏")>=0)&&(AntSusceptNum==0)){
					ExtTool.alert("提示","请选择药敏记录!");
					return ;
			}
			var OperationNum=this.AntOperation.getSelectionModel().getCount()
			if((UserReasonDesc.indexOf("预防-手术")>=0)&&(OperationNum==0)){
					ExtTool.alert("提示","请选择手术记录!");	
					return ;
			}
			if ((AntSusceptNum==0)&&(UserReasonDesc.indexOf("治疗")>=0)&&(this.Submission.getValue()=="N")){
					//ExtTool.alert("提示","请将该药品送检！!");
					//return;
			}
			if ((UserReasonDesc.indexOf("预防-手术")>=0)&&(this.AntSSYFTime.getValue()=="")){
					ExtTool.alert("提示","请选择预防用药使用时间！");  // add by qp 2014-04-21
					return;
			}
			var AntIndications=this.AntIndications.getValue()    //指征
			if(AntIndications==""){
					ExtTool.alert("提示","指征不能为空!");
					return;	
			}
			return true;	
		},
		GetReason:function(){	
			//组织数据 
			var ReasonInfo="";
				var AntSuscept=""
				this.AntSusceptNum=this.AntSuscept.getSelectionModel().getCount()
				if(this.AntSusceptNum>0){
						var arrlist = this.sm.getSelections();
					 	for (var rowIndex=0;rowIndex<arrlist.length;rowIndex++){
								var r = arrlist[rowIndex];
								AntSuscept=r.data.Rowid+"&"+AntSuscept
						}
						//AntSuscept=this.AntSuscept.getSelectionModel().getSelected().get("Rowid")   //药敏结果
				}
				var AntOperation=""
				this.OperationNum=this.AntOperation.getSelectionModel().getCount()
				if(this.OperationNum>0){
						AntOperation=this.AntOperation.getSelectionModel().getSelected().get("OperationRowid")   //手术记录
				} 
				var UserReasonDesc=this.UserReason.getRawValue()
				
				var CauseAna=this.CauseAna.getValue();    //原因分析
				var AntIndications=this.AntIndications.getValue()    //指征
				var Submission=this.Submission.getValue()     //经验送检
				var AntOtherReason="" ;  //this.AntOtherReason.getValue();    //其它理由
				var AntConscommt="" ;  //this.AntConscommt.getValue();        //专家会诊意见   此字段为空
				var UserReasonId=this.UserReasonId
				var UserReasonValue=this.UserReason.getValue(); 
				var AntBodyPart=this.AntBodyPart.getValue(); 
				var SSYFTime=this.AntSSYFTime.getValue()	
				var Para=UserReasonId+"^"+UserReasonValue+"^"+CauseAna+"^"+AntIndications+"^"+Submission+"^"+AntBodyPart+"^"+AntSuscept
				Para=Para+"^"+AntOperation+"^"+AntOtherReason+"^"+AntConscommt+"^"+session['LOGON.USERID']+"^"+this.ArcimRowid+"^"+this.EpisodeID+"^"+SSYFTime    //+"^"+this.SeqNoValue.getValue()
				return Para;
		},CancelAntReason:function(){
				//ownerCt获得该对象的上级对象
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
 * 编写日期:2012-07-23
 * 作者李宇峰tion
 * 说明抗菌药物管理里的登记表的保存界面
 * 名称AntMain.js
 */
AntApplyPan=function(EpisodeID,ArcimRowid,AntibApplyRowid,OrderPoisonCode,ShowTabStr){
		//住院号显示框
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
			,fieldLabel : "临时医嘱<font color='red'></font>"
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
			,fieldLabel : "是否越级使用"
			//,width:30
			});
		this.OrderIns = new Ext.form.ComboBox({
			id :'OrderIns'
			,minChars : 1
			,store : this.OrderInsStore
			,valueField : 'Rowid'
			,fieldLabel : "用法<font color='red'>*</font>",
			allowBlank:false,
			emptyText:"请选择用法"
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
					fieldLabel:"开始日期<font color='red'>*</font>",
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
					fieldLabel:"预计疗程(天)<font color='red'>*</font>",
					allowBlank:false,
					allowNegative:false,
					value:1,
					width : 20
		});
		
		AntApplyPan.superclass.constructor.call(this,{
					id:'AntReason',
					title:'2-申请信息',
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
					//获取申请单的信息
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
					var OrderInsterRowID=this.OrderIns.getValue();      //用法
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
 				//ownerCt获得该对象的上级对象
 				this.ownerCt.ownerCt.close()
 				
 		},CheckBeforeUpdate:function(){
	 			//校验数据，如果不合格，返回false，否则返回true
					var OrderInsterRowID=this.OrderIns.getValue();
					var OrderInster=this.OrderIns.getRawValue();
					if ((OrderInsterRowID=="")||(OrderInster=="")){
							ExtTool.alert("提示","用法不能为空!");
							return false;
					}
					var ApplyDate=this.OrderApplyDate.getValue()
					if (ApplyDate==""){
							ExtTool.alert("提示","开始日期不能为空!");
							return false;
					}
					var OrderDays=this.OrderDays.getValue();
					if (OrderDays==""){
						ExtTool.alert("提示","预计疗程不能为空!");
						return false;
						}
					return true;
 		},GetPatDetail:function(){
 					//病人信息
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
					//药品信息
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
					//申请单信息
					if(this.AntibApplyRowid!=""){
							//加载申请单信息
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
*  构造会诊申请信息
*/
AntConsultation=function(EpisodeID,ArcimRowid,AntibApplyRowid,OrderPoisonCode){
		//住院号显示框
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
			,fieldLabel : "会诊科室<font color='red'>*</font>",
			allowBlank:false,
			mode:'local',
			width:200,
			emptyText:"请选择科室"
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
			,fieldLabel : "会诊医生<font color='red'>*</font>",
			allowBlank:false,
			width:200,
			emptyText:"请选择医生"
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
					title:'3-会诊申请',
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
					//构造会诊信息 
					var Consultation="";
					//获取申请单的信息
					
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
					var ApplyTypeControl="P"              //直插入会诊时，是否要变状态。
					var UseReasonID=""           //this.ownerCt.ownerCt.UserReasonId
					var ConsultationDepRowID=this.AdmExcLoc.getValue() 
					var ConsultationDocRowID=this.AdmExcDoc.getValue();
					
					var OrderInsterRowID=""   //this.OrderIns.getValue();      //用法
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
 				//ownerCt获得该对象的上级对象
 				this.ownerCt.ownerCt.close()
 				
 		},CheckBeforeUpdate:function(){
	 			//校验数据，如果不合格，返回false，否则返回true
	 			
					var ConsultationDepRowID=this.AdmExcLoc.getValue()
					if((ConsultationDepRowID=="")&&(this.OrderPoisonCode=="KSS3")){
							ExtTool.alert("提示","会诊科室不能为空!");	
							return false;	
					}
					var ConsultationDocRowID=this.AdmExcDoc.getValue();
					if((ConsultationDocRowID=="")&&(this.OrderPoisonCode=="KSS3")){
							ExtTool.alert("提示","会诊医生不能为空!");	
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
				,text : '确定'
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
				text:'取消',
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
				//title:'已审核信息',
				//viewConfig: {forceFit: true},
				listeners:{
					},
				//buttons:[btnSave,btnCancel],
				columns:[
						this.AuditInfoSM,
						{header:'序号',dataIndex:'SeqNo',width:50},
						{header:'医嘱项',dataIndex:'ArcimName',width:180},
						{header:'审核状态',dataIndex:'Status'},
						{header:'申请人',dataIndex:'AppUser'},
						{header:'申请日期',dataIndex:'AppDate1'},
						{header:'申请时间',dataIndex:'AppTime1'},
						{header:'Rowid',dataIndex:'Rowid',hidden:true},
						{header:'StatusCode',dataIndex:'StatusCode',hidden:true},
						{header:'审核人',dataIndex:'AuditDoc'},
						{header:'审核日期',dataIndex:'AuditDate1'},
						{header:'审核时间',dataIndex:'AuditTime'},
						{header:'会诊医生',dataIndex:'ConsultDoc'},
						{header:'会诊日期',dataIndex:'ConsultDate'},
						{header:'CheckBoxOk',dataIndex:'CheckBoxOk',hidden:true}
						//{ header: "", dataIndex: "B_Cancel", width: 50,
 						//	renderer: function (value, cellmeta) { return "<INPUT type='button' value='删除'>";}
						//}
				]
			});
			
			
			/*
			*/
		var winAuditInfo = new Ext.Panel({
			height:420,
			iconCls:"c-useaim-icon",
			renderTo:Ext.getBody(),
			title:'抗菌药物申请列表',
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
				,text : '确定',
				iconCls:"icon-save",
				scope:this,
				handler:function(){ 
					winGetOrderFlag.close();  
						//Ext.getCmp('AuditAnt').close();
				}
	
		});
		var btnCancel=new Ext.Button({
				id:'btnCancel',
				text:'取消',
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
				//title:'已审核信息',
				//viewConfig: {forceFit: true},
				columns:[
						{header:'就诊号',dataIndex:'EpisodeID',width:80},
						{header:'病人姓名',dataIndex:'PAPMIName',width:100},
						{header:'药品名',dataIndex:'ARCICDesc',width:100},
						{header:'开医嘱时间',dataIndex:'ORSDate',width:102}
				]
			});
			
			
			/*
			*/
		var winGetOrderFlag=new Ext.Window({
				//id:'AuditAnt',
				height:200,
				width:400,
				title:'以下抗菌药物医嘱已经使用超过72小时,请处理！',
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