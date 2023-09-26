/**
 * auth.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
$(function(){
	var browserType = ANT.getBrowserType(),
		docAuthNum = $.trim(ANT.DHC.getDocAuthNum()),
		DOC9AUTHOBJ,
		MaskUtil = ANT.initEasyUIMask();
		//ANT.initCheckboxSetting("input");
		
	//ANT.initCheckboxSetting("#i-auth-dialog-add input");
	ANT.setComboWidth(browserType,"i-auth-condition-docnum");
	$('#i-auth-grid').simpledatagrid({
		singleSelect:true,
		fit:true,
		border:false,
		headerCls:'panel-header-gray',
		queryParams: {
			ClassName:"DHCAnt.KSS.Config.Authority",
			QueryName:"QryKSSAuthority",
			ModuleName:"datagrid",
			Arg1:"1",
			Arg2:"",Arg3:"",Arg4:"",
			Arg5:"",Arg6:"",Arg7:"",Arg8:"",
			Arg9:"",
			ArgCnt:9
		},
		toolbar:[{
						text:'���ļ���Ȩ��',
						id:'i-auth-levelAuthUpdate',
						iconCls: 'icon-levelauth',
						handler: function(){
						}
				},{
						text:'����ҽ��Ȩ��',
						id:'i-auth-docAuthUpdate',
						iconCls: 'icon-docauth',
						handler: function(){
						}
				},{
						text:'���Ĵ���Ȩ',
						id:'i-auth-docforbidden',
						iconCls: 'icon-antpresc',
						handler: function(){
						}
				},{
						text:'ɾ��ҽ��Ȩ��',
						id:'i-auth-docdelete',
						iconCls: 'icon-deleteauth',
						handler: function(){
						}
				}
					
		],
		columns:[[
			//{field:'ck',checkbox:false},
			{field:'CTCPTDesc',title:'ҽ������',width:100},
			{field:'ctDocDesc',title:'ҽ��',width:100},
			{field:'tppEpisodeType',title:'��������',width:100,
				formatter: function(value,row,index){
					if (row.tppEpisodeType == "I"){
						return "<span style='color:#337AB7;'>סԺ</span>";
					} else if (row.tppEpisodeType == "E") {
						return "<span style='color:red;'>����</span>";
					} else if (row.tppEpisodeType == "O") {
						return "<span style='color:green;'>����</span>";
					} else {
						return value;
					}
				}
			},
			{field:'phcpoDesc',title:'����ҩ�Ｖ��',width:200},
			{field:'tppControlTypeDesc',title:'��������',width:100},
			{field:'isKssAut',title:'�Ƿ�Ȩ�޵�ҽ��',width:100},
			{field:'docAut',title:'ҽ������Ȩ',width:100},
			{field:'tppChkVerify',title:'���Ȩ��',width:100},
			{field:'id',title:'��ID',width:100,hidden:true},
			{field:'rowId',title:'ҽ������ID',width:100,hidden:true},
			{field:'ctDocId',title:'ҽ��ID',width:100,hidden:true},
			{field:'tppPoisonDr',title:'����ҩ�Ｖ��ID',width:100,hidden:true}
		]]
		/*
		onLoadSuccess: function(data){
			$(this).parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
			if (data.rows.length > 0) {
				for (var i = 0; i < data.rows.length; i++) {
					//$("#i-auth-container .datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']").addClass("hisui-checkbox");
					//$("#i-auth-container .datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']").remove();
					
					$("#i-auth-container .datagrid-row[datagrid-row-index=" + i + "]").find(".datagrid-cell-check").addClass("hischeckbox_square-blue");
					$("#i-auth-container .datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']").attr({
						"style": "position: absolute; opacity: 1;",
					})
					$html1 = '<input type="checkbox" name="ck" value="">';
					//$html='<input class="hisui-checkbox" type="checkbox" label="�Ѿ���">';
					//$("#i-auth-container .datagrid-row[datagrid-row-index=" + i + "]").find(".datagrid-cell-check").remove();
					//$("#i-auth-container .datagrid-row[datagrid-row-index=" + i + "] td[field='ck']").append($html);
				};
			};
		}*/
	});
	
	$('#i-auth-condition-docLevel').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryDoctorLevl";
			param.ModuleName="combobox";
			param.ArgCnt=0;
		},
		onSelect:function(record) {
			if(!$("#i-auth-condition-switch").is(':checked')){
				var loc = $('#i-auth-condition-loc').simplecombobox("getValue")||"";
				$('#i-auth-condition-docname').simplecombobox({
					onBeforeLoad: function(param){
						param.ClassName="DHCAnt.KSS.Config.Authority";
						param.QueryName="QryDoctor";
						param.ModuleName="combobox";
						param.Arg1= loc;
						param.Arg2=record.id;
						param.ArgCnt=2;
					}
				});
				//����HISUIBUG QP 2018-04-28
				//ANT.DHC.setHUICombo(browserType);
				
			}
		},
		onUnselect: function () {
			$(this).simplecombobox('setValue', '');
			
			if(!$("#i-auth-condition-switch").is(':checked')){
				var loc = $('#i-auth-condition-loc').simplecombobox("getValue");
				$('#i-auth-condition-docname').simplecombobox({
					onBeforeLoad: function(param){
						param.ClassName="DHCAnt.KSS.Config.Authority";
						param.QueryName="QryDoctor";
						param.ModuleName="combobox";
						param.Arg1= loc;
						param.Arg2= "";
						param.ArgCnt=2;
					}
				});
			}
		}
	});
	
	$('#i-auth-condition-loc').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryGetdep";
			param.ModuleName="combobox";
			param.Arg1="";
			param.ArgCnt=1;
		},
		editable:true,
		/*
		mode: "local",
		filter: function(q, row){  
			var opts = $(this).combobox('options');  
			return row[opts.textField].indexOf(q) == 0;  
		},
		*/
		onSelect:function(record) {
			if(!$("#i-auth-condition-switch").is(':checked')){
				var docLevel = $('#i-auth-condition-docLevel').simplecombobox("getValue");
				$('#i-auth-condition-docname').simplecombobox({
					onBeforeLoad: function(param){
						param.ClassName="DHCAnt.KSS.Config.Authority";
						param.QueryName="QryDoctor";
						param.ModuleName="combobox";
						param.Arg1=record.id;
						param.Arg2=docLevel;
						param.ArgCnt=2;
					}
				});
				//����HISUIBUG QP 2018-04-28
				//ANT.DHC.setHUICombo(browserType);
				$('#i-auth-condition-docname').simplecombobox("enable");
			}
			
		},
		onUnselect: function () {
			$(this).simplecombobox('setValue', '');
			if(!$("#i-auth-condition-switch").is(':checked')){
				var docLevel = $('#i-auth-condition-docLevel').simplecombobox("getValue");
				$('#i-auth-condition-docname').simplecombobox({
					onBeforeLoad: function(param){
						param.ClassName="DHCAnt.KSS.Config.Authority";
						param.QueryName="QryDoctor";
						param.ModuleName="combobox";
						param.Arg1= "";
						param.Arg2= docLevel;
						param.ArgCnt=2;
					}
				});
			}
		}
	});
	
	$('#i-auth-condition-admType').localcombobox({
		data: [{id: 'O', text: '����'}, {id: 'E',text: '����'}, {id: 'I',text: 'סԺ'}]
	});
	
	$('#i-auth-condition-kssLevel').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryKSSLevl";
			param.ModuleName="combobox";
			param.ArgCnt=0;
		}
	});
	
	$('#i-auth-condition-docname').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryDoctor";
			param.ModuleName="combobox";
			param.Arg1="";
			param.Arg2="";
			param.ArgCnt=2;
		}
	});
	
	$("#i-auth-condition-switch").on('ifChecked', function(){
		if ($("#i-auth-condition-prescAuth").is(':checked')) {
			$("#i-auth-condition-prescAuth").iCheck('uncheck'); 
		};
		$("#i-auth-condition-loc").simplecombobox("setValue","");
		$("#i-auth-condition-docname").simplecombobox("setValue","");
		$("#i-auth-condition-docnum").val("");
		$("#i-auth-condition-loc").simplecombobox("disable");
		$("#i-auth-condition-docname").simplecombobox("disable");
		$("#i-auth-condition-docnum").attr("disabled","disabled");
		
	});
	
	$("#i-auth-condition-switch").on('ifUnchecked', function(){
		$("#i-auth-condition-docname").simplecombobox("enable");
		$("#i-auth-condition-loc").simplecombobox("enable");
		$("#i-auth-condition-docnum").removeAttr("disabled");
		var docLevel = $('#i-auth-condition-docLevel').simplecombobox("getValue");
		$('#i-auth-condition-docname').simplecombobox({
			onBeforeLoad: function(param){
				param.ClassName="DHCAnt.KSS.Config.Authority";
				param.QueryName="QryDoctor";
				param.ModuleName="combobox";
				param.Arg1="";
				param.Arg2=docLevel;
				param.ArgCnt=2;
			}
		});
		//����HISUIBUG QP 2018-04-28
		//ANT.DHC.setHUICombo(browserType);
	});
	
	$("#i-auth-condition-prescAuth").on('ifChecked', function(){
		$("#i-auth-condition-switch").iCheck('uncheck'); 
		$("#i-auth-condition-verifyAuth").iCheck('uncheck'); 
		$("#i-auth-condition-docLevel").simplecombobox("setValue","");
		$("#i-auth-condition-loc").simplecombobox("setValue","");
		$("#i-auth-condition-docname").simplecombobox("setValue","");
		$("#i-auth-condition-docnum").val("");
		$("#i-auth-condition-admType").simplecombobox("setValue","");
		$("#i-auth-condition-kssLevel").simplecombobox("setValue","");
		
		$("#i-auth-condition-docLevel").simplecombobox("disable");
		$("#i-auth-condition-loc").simplecombobox("disable");
		//$("#i-auth-condition-docname").simplecombobox("disable");
		$("#i-auth-condition-docnum").attr("disabled","disabled");
		$("#i-auth-condition-admType").localcombobox("disable");
		$("#i-auth-condition-kssLevel").simplecombobox("disable");
		
		$('#i-auth-condition-docname').simplecombobox({
			onBeforeLoad: function(param){
				param.ClassName="DHCAnt.KSS.Config.Authority";
				param.QueryName="QryDoctor";
				param.ModuleName="combobox";
				param.Arg1="";
				param.Arg2="";
				param.ArgCnt=2;
			}
		});
		//����HISUIBUG QP 2018-04-28
		//ANT.DHC.setHUICombo(browserType);
		
			
	});
	
	$("#i-auth-condition-prescAuth").on('ifUnchecked', function(){
		$("#i-auth-condition-docLevel").simplecombobox("enable");
		$("#i-auth-condition-loc").simplecombobox("enable");
		$("#i-auth-condition-docname").simplecombobox("enable");
		$("#i-auth-condition-docnum").removeAttr("disabled");
		$("#i-auth-condition-admType").localcombobox("enable");
		$("#i-auth-condition-kssLevel").simplecombobox("enable");
	})
	
	$("#i-auth-condition-verifyAuth").on('ifChecked', function(){
		$("#i-auth-condition-prescAuth").iCheck('uncheck'); 
			
	});
	
	$("#i-auth-find").on('click', function(){
		reloadAuthGrid();
	});
	
	function drawAuthDialog(selector, admType, appType){
		if (selector == "i-auth-dialog") {	//�޸�
			$("#" + selector + " input[name='docLevel']").simplecombobox({
				disabled: true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryDoctorLevl";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
			
			$("#" + selector + " input[name='admType']").localcombobox({
				disabled: true,
				data: [{id: 'O', text: '����'}, {id: 'E',text: '����'}, {id: 'I',text: 'סԺ'}],
				value: admType
			});
			
			$("#" + selector + " input[name='kssLevel']").simplecombobox({
				disabled: true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryKSSLevl";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
			
			$("#" + selector + "-appType").localcombobox({
				required:true,
				data: [{id: 'A', text: '��ʾ'}, {id: 'P',text: '���뵥'}, {id: 'E',text: 'Խ��'}, {id: 'F',text: '��ֹ'}],
				value: appType
			});
			
		} else {
			$("#" + selector + " input[name='docLevel']").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryDoctorLevl";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
			
			$("#" + selector + " input[name='admType']").localcombobox({
				required:true,
				data: [{id: 'O', text: '����'}, {id: 'E',text: '����'}, {id: 'I',text: 'סԺ'}],
				value: admType
			});
			
			$("#" + selector + " input[name='kssLevel']").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryKSSLevl";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
		
		}
		
		$("#" + selector + " input[name='appType']").localcombobox({
			required:true,
			data: [{id: 'A', text: '��ʾ'}, {id: 'P',text: '���뵥'}, {id: 'E',text: 'Խ��'}, {id: 'F',text: '��ֹ'}],
			value: appType
		});
	
	};
	
	function build9DocAuthInfo (docAuthNum,flag,docAuthObj) {
		var OKSS1Info="",OKSS2Info="",OKSS3Info="",
			EKSS1Info="",EKSS2Info="",EKSS3Info="",
			IKSS1Info="",IKSS2Info="",IKSS3Info="";
		var OKSS1Verify=0,OKSS2Verify=0,OKSS3Verify=0,
			EKSS1Verify=0,EKSS2Verify=0,EKSS3Verify=0,
			IKSS1Verify=0,IKSS2Verify=0,IKSS3Verify=0;
		var OKSS1MainId="",OKSS2MainId="",OKSS3MainId="",
			EKSS1MainId="",EKSS2MainId="",EKSS3MainId="",
			IKSS1MainId="",IKSS2MainId="",IKSS3MainId="";
		var OKSS1ItemId="",OKSS2ItemId="",OKSS3ItemId="",
			EKSS1ItemId="",EKSS2ItemId="",EKSS3ItemId="",
			IKSS1ItemId="",IKSS2ItemId="",IKSS3ItemId="";
		var OKSS1Control="",OKSS2Control="",OKSS3Control="",
			EKSS1Control="",EKSS2Control="",EKSS3Control="",
			IKSS1Control="",IKSS2Control="",IKSS3Control="";
		if (!!flag) {
			var docLevel = $("#i-9docAuth-docLevel").simplecombobox('getValue'),
			doc = $("#i-9docAuth-doc").simplecombobox('getValue');
		} else {
			var docLevel = $("#i-9docAuth-docLevel").val(),
			doc = $("#i-9docAuth-doc").val();
		};
		var FG="^",FG2="!",mRtn="";
		
		//Ȩ��
		if (docAuthNum == 3) {
			OKSS1Control = EKSS1Control = IKSS1Control = $("#i-9docAuth-IKSS1-control").localcombobox('getValue');
			OKSS2Control = EKSS2Control = IKSS2Control = $("#i-9docAuth-IKSS2-control").localcombobox('getValue');
			OKSS3Control = EKSS3Control = IKSS3Control = $("#i-9docAuth-IKSS3-control").localcombobox('getValue');
		};
		if (docAuthNum == 9) {
			OKSS1Control = $("#i-9docAuth-OKSS1-control").localcombobox('getValue');
			OKSS2Control = $("#i-9docAuth-OKSS2-control").localcombobox('getValue');
			OKSS3Control = $("#i-9docAuth-OKSS3-control").localcombobox('getValue');
		
			EKSS1Control = $("#i-9docAuth-EKSS1-control").localcombobox('getValue');
			EKSS2Control = $("#i-9docAuth-EKSS2-control").localcombobox('getValue');
			EKSS3Control = $("#i-9docAuth-EKSS3-control").localcombobox('getValue');
		
			IKSS1Control = $("#i-9docAuth-IKSS1-control").localcombobox('getValue');
			IKSS2Control = $("#i-9docAuth-IKSS2-control").localcombobox('getValue');
			IKSS3Control = $("#i-9docAuth-IKSS3-control").localcombobox('getValue');
		};
		
		//id
		if (!!!flag) {
			if (docAuthNum == 3) {
				OKSS1ItemId = docAuthObj.OAuth.kss1ItemId;
				EKSS1ItemId = docAuthObj.EAuth.kss1ItemId;
				IKSS1ItemId = $("#i-9docAuth-IKSS1-itemId").val();
				
				OKSS2ItemId = docAuthObj.OAuth.kss2ItemId;
				EKSS2ItemId = docAuthObj.EAuth.kss2ItemId;
				IKSS2ItemId = $("#i-9docAuth-IKSS2-itemId").val();
				
				OKSS3ItemId = docAuthObj.OAuth.kss3ItemId;
				EKSS3ItemId = docAuthObj.EAuth.kss3ItemId;
				IKSS3ItemId = $("#i-9docAuth-IKSS3-itemId").val();
			};
			if (docAuthNum == 9) {
				OKSS1ItemId = $("#i-9docAuth-OKSS1-itemId").val();
				OKSS2ItemId = $("#i-9docAuth-OKSS2-itemId").val();
				OKSS3ItemId = $("#i-9docAuth-OKSS3-itemId").val();
				
				EKSS1ItemId = $("#i-9docAuth-EKSS1-itemId").val();
				EKSS2ItemId = $("#i-9docAuth-EKSS2-itemId").val();
				EKSS3ItemId = $("#i-9docAuth-EKSS3-itemId").val();
				
				IKSS1ItemId = $("#i-9docAuth-IKSS1-itemId").val();
				IKSS2ItemId = $("#i-9docAuth-IKSS2-itemId").val();
				IKSS3ItemId = $("#i-9docAuth-IKSS3-itemId").val();
			};
			
			//����id����
			var mStry = OKSS1ItemId.match(/\|+/g);
			if ( mStry && (mStry.length == "1") ) {
				OKSS1MainId = OKSS1ItemId;
				OKSS1ItemId = "";
			};
			mStry = OKSS2ItemId.match(/\|+/g);
			if ( mStry && (mStry.length == "1") ) {
				OKSS2MainId = OKSS2ItemId;
				OKSS2ItemId = "";
			};
			mStry = OKSS3ItemId.match(/\|+/g);
			if ( mStry && (mStry.length == "1") ) {
				OKSS3MainId = OKSS3ItemId;
				OKSS3ItemId = "";
			};
			//����id����
			mStry = EKSS1ItemId.match(/\|+/g);
			if ( mStry && (mStry.length == "1")) {
				EKSS1MainId = EKSS1ItemId;
				EKSS1ItemId = "";
			};
			mStry = EKSS2ItemId.match(/\|+/g);
			if (mStry && (mStry.length == "1") ) {
				EKSS2MainId = EKSS2ItemId;
				EKSS2ItemId = "";
			};
			mStry = EKSS3ItemId.match(/\|+/g);
			if ( mStry && (mStry.length == "1") ) {
				EKSS3MainId = EKSS3ItemId;
				EKSS3ItemId = "";
			};
			//סԺid����
			mStry = IKSS1ItemId.match(/\|+/g);
			if ( mStry && (mStry.length == "1") ) {
				IKSS1MainId = IKSS1ItemId;
				IKSS1ItemId = "";
			};
			mStry = IKSS2ItemId.match(/\|+/g);
			if ( mStry && (mStry.length == "1") ) {
				IKSS2MainId = IKSS2ItemId;
				IKSS2ItemId = "";
			};
			mStry = IKSS3ItemId.match(/\|+/g);
			if ( mStry && (mStry.length == "1") ) {
				IKSS3MainId = IKSS3ItemId;
				IKSS3ItemId = "";
			};
				
		};
		
		if (docAuthNum == 3) {
			//סԺverify
			if($("#i-9docAuth-IKSS1-verify").is(':checked')) {
				OKSS1Verify = EKSS1Verify = IKSS1Verify = 1;
			};
			if($("#i-9docAuth-IKSS2-verify").is(':checked')) {
				OKSS2Verify = EKSS2Verify = IKSS2Verify = 1;
			};
			if($("#i-9docAuth-IKSS3-verify").is(':checked')) {
				OKSS3Verify = EKSS3Verify = IKSS3Verify = 1;
			};
		};
		if (docAuthNum == 9) {
			//����verify
			if($("#i-9docAuth-OKSS1-verify").is(':checked')) {
				OKSS1Verify = 1;
			};
			if($("#i-9docAuth-OKSS2-verify").is(':checked')) {
				OKSS2Verify = 1;
			};
			if($("#i-9docAuth-OKSS3-verify").is(':checked')) {
				OKSS3Verify = 1;
			};
			//����verify
			if($("#i-9docAuth-EKSS1-verify").is(':checked')) {
				EKSS1Verify = 1;
			};
			if($("#i-9docAuth-EKSS2-verify").is(':checked')) {
				EKSS2Verify = 1;
			};
			if($("#i-9docAuth-EKSS3-verify").is(':checked')) {
				EKSS3Verify = 1;
			};
			//סԺverify
			if($("#i-9docAuth-IKSS1-verify").is(':checked')) {
				IKSS1Verify = 1;
			};
			if($("#i-9docAuth-IKSS2-verify").is(':checked')) {
				IKSS2Verify = 1;
			};
			if($("#i-9docAuth-IKSS3-verify").is(':checked')) {
				IKSS3Verify = 1;
			};
		};
		
		
		
		OKSS1Info = OKSS1ItemId + FG + doc + FG + docLevel + FG + "KSS1" + FG + OKSS1Control + FG + "O" + FG + OKSS1Verify + FG + OKSS1MainId;
		OKSS2Info = OKSS2ItemId + FG + doc + FG + docLevel + FG + "KSS2" + FG + OKSS2Control + FG + "O" + FG + OKSS2Verify + FG + OKSS2MainId;
		OKSS3Info = OKSS3ItemId + FG + doc + FG + docLevel + FG + "KSS3" + FG + OKSS3Control + FG + "O" + FG + OKSS3Verify + FG + OKSS3MainId;
		
		EKSS1Info = EKSS1ItemId + FG + doc + FG + docLevel + FG + "KSS1" + FG + EKSS1Control + FG + "E" + FG + EKSS1Verify + FG + EKSS1MainId;
		EKSS2Info = EKSS2ItemId + FG + doc + FG + docLevel + FG + "KSS2" + FG + EKSS2Control + FG + "E" + FG + EKSS2Verify + FG + EKSS2MainId;
		EKSS3Info = EKSS3ItemId + FG + doc + FG + docLevel + FG + "KSS3" + FG + EKSS3Control + FG + "E" + FG + EKSS3Verify + FG + EKSS3MainId;
		
		IKSS1Info = IKSS1ItemId + FG + doc + FG + docLevel + FG + "KSS1" + FG + IKSS1Control + FG + "I" + FG + IKSS1Verify + FG + IKSS1MainId;
		IKSS2Info = IKSS2ItemId + FG + doc + FG + docLevel + FG + "KSS2" + FG + IKSS2Control + FG + "I" + FG + IKSS2Verify + FG + IKSS2MainId;
		IKSS3Info = IKSS3ItemId + FG + doc + FG + docLevel + FG + "KSS3" + FG + IKSS3Control + FG + "I" + FG + IKSS3Verify + FG + IKSS3MainId;
		
		if (!!OKSS1Control)  {
			if (mRtn == "")  {mRtn = OKSS1Info;}
			else { mRtn = mRtn + FG2 + OKSS1Info;}
		}
		if (!!OKSS2Control)  {
			if (mRtn == "")  {mRtn = OKSS2Info;}
			else { mRtn = mRtn + FG2 + OKSS2Info;}
		}
		if (!!OKSS3Control)  {
			if (mRtn == "")  {mRtn = OKSS3Info;}
			else { mRtn = mRtn + FG2 + OKSS3Info;}
		}
		
		//
		if (!!EKSS1Control)  {
			if (mRtn == "")  {mRtn = EKSS1Info;}
			else { mRtn = mRtn + FG2 + EKSS1Info;}
		}
		if (!!EKSS2Control)  {
			if (mRtn == "")  {mRtn = EKSS2Info;}
			else { mRtn = mRtn + FG2 + EKSS2Info;}
		}
		if (!!EKSS3Control)  {
			if (mRtn == "")  {mRtn = EKSS3Info;}
			else { mRtn = mRtn + FG2 + EKSS3Info;}
		}
		
		//
		if (!!IKSS1Control)  {
			if (mRtn == "")  {mRtn = IKSS1Info;}
			else { mRtn = mRtn + FG2 + IKSS1Info;}
		}
		if (!!IKSS2Control)  {
			if (mRtn == "")  {mRtn = IKSS2Info;}
			else { mRtn = mRtn + FG2 + IKSS2Info;}
		}
		if (!!IKSS3Control)  {
			if (mRtn == "")  {mRtn = IKSS3Info;}
			else { mRtn = mRtn + FG2 + IKSS3Info;}
		}
		
		return mRtn;
	};
	
	function set9AuthDocVerify(docAuthObj) {
		if (!!docAuthObj) {
			//����
			if (docAuthObj.OAuth.kss1Verify == "Y") {
				$("#i-9docAuth-OKSS1-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-OKSS1-verify").iCheck('uncheck'); 
			};
			
			if (docAuthObj.OAuth.kss2Verify == "Y") {
				$("#i-9docAuth-OKSS2-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-OKSS2-verify").iCheck('uncheck'); 
			};
			
			if (docAuthObj.OAuth.kss3Verify == "Y") {
				$("#i-9docAuth-OKSS3-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-OKSS3-verify").iCheck('uncheck'); 
			};
			
			//����
			if (docAuthObj.EAuth.kss1Verify == "Y") {
				$("#i-9docAuth-EKSS1-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-EKSS1-verify").iCheck('uncheck'); 
			};
			
			if (docAuthObj.EAuth.kss2Verify == "Y") {
				$("#i-9docAuth-EKSS2-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-EKSS2-verify").iCheck('uncheck'); 
			};
			
			if (docAuthObj.EAuth.kss3Verify == "Y") {
				$("#i-9docAuth-EKSS3-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-EKSS3-verify").iCheck('uncheck'); 
			};
			
			//סԺ
			if (docAuthObj.IAuth.kss1Verify == "Y") {
				$("#i-9docAuth-IKSS1-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-IKSS1-verify").iCheck('uncheck'); 
			};
			
			if (docAuthObj.IAuth.kss2Verify == "Y") {
				$("#i-9docAuth-IKSS2-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-IKSS2-verify").iCheck('uncheck'); 
			};
			
			if (docAuthObj.IAuth.kss3Verify == "Y") {
				$("#i-9docAuth-IKSS3-verify").iCheck('check'); 
			} else {
				$("#i-9docAuth-IKSS3-verify").iCheck('uncheck'); 
			};
		} else {
			$("#i-9docAuth-OKSS1-verify").iCheck('uncheck'); 
			$("#i-9docAuth-OKSS2-verify").iCheck('uncheck');
			$("#i-9docAuth-OKSS3-verify").iCheck('uncheck'); 
			$("#i-9docAuth-EKSS1-verify").iCheck('uncheck'); 
			$("#i-9docAuth-EKSS2-verify").iCheck('uncheck'); 
			$("#i-9docAuth-EKSS3-verify").iCheck('uncheck'); 
			$("#i-9docAuth-IKSS1-verify").iCheck('uncheck'); 
			$("#i-9docAuth-IKSS2-verify").iCheck('uncheck'); 
			$("#i-9docAuth-IKSS3-verify").iCheck('uncheck'); 
		}
	};
	
	function init9AuthDocBaseInfo(docAuthObj){
		$("#i-9docAuth-docLevel").simplecombobox({
			required:true,
			onBeforeLoad: function(param){
				param.ClassName="DHCAnt.KSS.Config.Authority";
				param.QueryName="QryDoctorLevl";
				param.ModuleName="combobox";
				param.ArgCnt=0;
			},
			onSelect: function(record){
				$("#i-9docAuth-doc").simplecombobox('clear');
				$("#i-9docAuth-doc").simplecombobox({
					required:true,
					onBeforeLoad: function(param){
						param.ClassName="DHCAnt.KSS.Config.Authority";
						param.QueryName="QryDoctor";
						param.ModuleName="combobox";
						param.Arg1="";
						param.Arg2=record.id;
						param.ArgCnt=2;
					}
				});
			},onUnselect:function(){
				$("#i-9docAuth-doc").simplecombobox('clear');
				$("#i-9docAuth-doc").simplecombobox({
					required:true,
					onBeforeLoad: function(param){
						param.ClassName="DHCAnt.KSS.Config.Authority";
						param.QueryName="QryDoctor";
						param.ModuleName="combobox";
						param.Arg1="";
						param.Arg2="";
						param.ArgCnt=2;
					}
				});
			}
		});
			
		$("#i-9docAuth-doc").simplecombobox({
			required:true,
			onBeforeLoad: function(param){
				param.ClassName="DHCAnt.KSS.Config.Authority";
				param.QueryName="QryDoctor";
				param.ModuleName="combobox";
				param.Arg1="";
				param.Arg2="";
				param.ArgCnt=2;
			}
		});
	};
	
	function draw9AuthDocDialog(docAuthObj){
		var mData = [{id: 'A', text: '��ʾ'}, {id: 'P',text: '���뵥'}, 
					{id: 'E',text: 'Խ��'}, {id: 'F',text: '��ֹ'}];
		
		if (!!docAuthObj) {
			$("#i-9docAuth-IKSS3-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.IAuth.kss3Control
			});
			$("#i-9docAuth-IKSS2-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.IAuth.kss2Control
			});
			$("#i-9docAuth-IKSS1-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.IAuth.kss1Control
			});
			
			$("#i-9docAuth-EKSS3-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.EAuth.kss3Control
			});
			$("#i-9docAuth-EKSS2-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.EAuth.kss2Control
			});
			$("#i-9docAuth-EKSS1-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.EAuth.kss1Control
			});
			
			$("#i-9docAuth-OKSS3-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.OAuth.kss3Control
			});
			$("#i-9docAuth-OKSS2-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.OAuth.kss2Control
			});
			$("#i-9docAuth-OKSS1-control").localcombobox({
				//required:true,
				data: mData,
				value: docAuthObj.OAuth.kss1Control
			});
		} else {
			$("#i-9docAuth-IKSS3-control").localcombobox({
				//required:true,
				data: mData,
			});
			$("#i-9docAuth-IKSS2-control").localcombobox({
				//required:true,
				data: mData,
			});
			$("#i-9docAuth-IKSS1-control").localcombobox({
				//required:true,
				data: mData,
			});
			
			$("#i-9docAuth-EKSS3-control").localcombobox({
				//required:true,
				data: mData,
			});
			$("#i-9docAuth-EKSS2-control").localcombobox({
				//required:true,
				data: mData,
			});
			$("#i-9docAuth-EKSS1-control").localcombobox({
				//required:true,
				data: mData,
			});
			
			$("#i-9docAuth-OKSS3-control").localcombobox({
				//required:true,
				data: mData,
			});
			$("#i-9docAuth-OKSS2-control").localcombobox({
				//required:true,
				data: mData,
			});
			$("#i-9docAuth-OKSS1-control").localcombobox({
				//required:true,
				data: mData,
			});
		}
	}
	function drawAuthDocDialog(selector, admType, appType, doc){
		if (selector == "i-auth-docdialog") {
			
			$("#" + selector + " input[name='admType']").localcombobox({
				disabled: true,
				data: [{id: 'O', text: '����'}, {id: 'E',text: '����'}, {id: 'I',text: 'סԺ'}],
				value:admType
			});
			$("#" + selector + "-appType").localcombobox({
				required:true,
				data: [{id: 'A', text: '��ʾ'}, {id: 'P',text: '���뵥'}, {id: 'E',text: 'Խ��'}, {id: 'F',text: '��ֹ'}],
				value: appType
			});
			
			$("#" + selector + " input[name='kssLevel']").simplecombobox({
				disabled: true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryKSSLevl";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
			
			$("#" + selector + " input[name='docLevel']").simplecombobox({
				disabled: true,
				value: admType,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryDoctorLevl";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
			
			$("#" + selector + "-docname").simplecombobox({
				disabled: true,
				value: doc,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryDoctor";
					param.ModuleName="combobox";
					param.Arg1="";
					param.Arg2="";
					param.ArgCnt=2;
				}
			});
			
		} else {
			$("#" + selector + " input[name='admType']").localcombobox({
				required:true,
				data: [{id: 'O', text: '����'}, {id: 'E',text: '����'}, {id: 'I',text: 'סԺ'}],
				value: admType
			});
			
			$("#" + selector + " input[name='kssLevel']").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryKSSLevl";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
			
			$("#" + selector + " input[name='docLevel']").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryDoctorLevl";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},
				onSelect: function(record){
					$("#i-auth-docdialog-add-docname").simplecombobox('clear');
					$("#i-auth-docdialog-add-docname").simplecombobox({
						required:true,
						onBeforeLoad: function(param){
							param.ClassName="DHCAnt.KSS.Config.Authority";
							param.QueryName="QryDoctor";
							param.ModuleName="combobox";
							param.Arg1="";
							param.Arg2=record.id;
							param.ArgCnt=2;
						}
					});
				},onUnselect:function(){
					$("#i-auth-docdialog-add-docname").simplecombobox('clear');
					$("#i-auth-docdialog-add-docname").simplecombobox({
						required:true,
						onBeforeLoad: function(param){
							param.ClassName="DHCAnt.KSS.Config.Authority";
							param.QueryName="QryDoctor";
							param.ModuleName="combobox";
							param.Arg1="";
							param.Arg2="";
							param.ArgCnt=2;
						}
					});
				}
			});
			
			$("#i-auth-docdialog-add-docname").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryDoctor";
					param.ModuleName="combobox";
					param.Arg1="";
					param.Arg2="";
					param.ArgCnt=2;
				}
			});
			
			$("#" + selector + " input[name='appType']").localcombobox({
				required:true,
				data: [{id: 'A', text: '��ʾ'}, {id: 'P',text: '���뵥'}, {id: 'E',text: 'Խ��'}, {id: 'F',text: '��ֹ'}],
				value: appType
			});
		};
		
	};
	
	$("#i-auth-levelAuthUpdate").on('click', function(){
		var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected){
			var dialogStr = "<div id='i-auth-dialog-add' class='c-auth-dialog container'>" +
							"<input type='hidden' name='id' />" +
							"<div class='row'>"  +
								"<div class='col-xs-6'><span class='c-span'>ҽ������</span><input type='text' name='docLevel'/></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input type='text' name='admType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input type='text' name='kssLevel' /></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input type='text' name='appType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>���Ȩ��</span><input type='checkbox' name='isAudit' /></div>" +
								"<div class='col-xs-6'><a id='i-auth-dialog-add-save' class='btn btn-info c-btn'>����</a></div>" +
							"</div>" + 
					"</div>";
			var $dialogStr = $(dialogStr);
			$("#i-auth-container").append($dialogStr);
			$("#i-auth-dialog-add input[name='isAudit']").iCheck({
				labelHover : false,
				cursor : true,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});
			drawAuthDialog("i-auth-dialog-add", "", "");
			$("#i-auth-dialog-add input[name='id']").val("");
			$("#i-auth-dialog-add input[name='docLevel']").val("");
			$("#i-auth-dialog-add input[name='kssLevel']").val("");
			$("#i-auth-dialog-add input[name='appType']").val("");
			$("#i-auth-dialog-add input[name='admType']").val("");
			$("#i-auth-dialog-add input[name='isAudit']").iCheck('uncheck'); 
			
			$('#i-auth-dialog-add').window({
				title: '���ҽ������Ȩ��',
				modal: true,
				minimizable:false,
				iconCls:'fa fa-plus-circle',
				maximizable:false,
				collapsible:false,
				onClose: function () {
					$("#i-auth-dialog-add").window('destroy');
					$dialogStr.remove();
				}
			});
			$("#i-auth-dialog-add-save").on('click', function(){
				var id = $("#i-auth-dialog-add input[name='id']").val();
				var docLevel = $("#i-auth-dialog-add input[name='docLevel']").val()||"";
				var kssLevel = $("#i-auth-dialog-add input[name='kssLevel']").val()||"";
				var appType = $("#i-auth-dialog-add input[name='appType']").val()||"";
				var admType = $("#i-auth-dialog-add input[name='admType']").val()||"";
				var isAudit=0
				
				if($("#i-auth-dialog-add input[name='isAudit']").is(':checked')){
					isAudit=1
				};
				var tempFlag = (!!docLevel)&&(!!kssLevel)&&(!!appType)&&(!!admType)
				if (!tempFlag) {
					layer.alert("����д�ñ����ֶ�...", {title:'��ʾ',icon: 0}); 
					return false;
				};
				var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","AddDHCCarPrvTpPHPoison", docLevel, kssLevel, appType, admType, isAudit);
				if (rtn == "-202") {
					layer.alert("�����Ѵ��ڣ�����Ҫ���...", {title:'��ʾ',icon: 0}); 
					return false;
				}
				if (rtn !="0") {
					layer.alert("���ʧ��...", {title:'��ʾ',icon: 2}); 
					return false;
				}
				layer.alert("��ӳɹ�...", {title:'��ʾ',icon: 1}); 
				$('#i-auth-dialog-add').window('close');
				reloadAuthGrid();

			});
			
			
		} else {
			if (selected.ctDocId != "") {
				//$.messager.alert('��ʾ','����ҽ�������¼�������޸�...','info');
				layer.alert("����ҽ�������¼�������޸�...", {
					title:'<i class="fa fa-hand-o-right" style="margin-right:4px;"></i>��ʾ',
					icon: 0
				}); 
				return false;
			}
			var domStr = "<div id='i-auth-dialog' class='c-auth-dialog container'>" +
							"<input type='hidden' name='id' />" +
							"<div class='row'>"  +
								"<div class='col-xs-6'><span class='c-span'>ҽ������</span><input type='text' name='docLevel'/></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input type='text' name='admType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input type='text' name='kssLevel' /></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input type='text' name='appType' id='i-auth-dialog-appType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>���Ȩ��</span><input type='checkbox' name='isAudit' /></div>" +
								"<div class='col-xs-6'><a id='i-auth-dialog-save' class='btn btn-info c-btn'>����</a></div>" +
							"</div>" + 
					"</div>";
			var $domStr = $(domStr);
			$("#i-auth-container").append($domStr);
			$("#i-auth-dialog input[name='isAudit']").iCheck({
				labelHover : false,
				cursor : true,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});
			drawAuthDialog("i-auth-dialog", selected.tppEpisodeType, selected.tppControlType);
			$("#i-auth-dialog input[name='id']").val(selected.id);	//����id
			$("#i-auth-dialog input[name='docLevel']").val(selected.rowId);
			$("#i-auth-dialog input[name='kssLevel']").val(selected.tppPoisonDr).attr("disabled","disabled");
			//$("#i-auth-dialog input[name='appType']").val(selected.tppControlType);
			$("#i-auth-dialog-appType").combobox('setValue',selected.tppControlType);
			$("#i-auth-dialog input[name='admType']").val(selected.tppEpisodeType).attr("disabled","disabled");
			if (selected.tppChkVerify == 1) {
				$("#i-auth-dialog input[name='isAudit']").iCheck('check'); 
			} else {
				$("#i-auth-dialog input[name='isAudit']").iCheck('uncheck'); 
			};
			
			$('#i-auth-dialog').window({
				title: '�޸�ҽ������Ȩ��',
				modal: true,
				iconCls:'fa fa-pencil',
				minimizable:false,
				maximizable:false,
				maximizable:false,
				collapsible:false,
				onClose: function () {
					$("#i-auth-dialog").window('destroy');
					$domStr.remove();
				}
			});
			
			$("#i-auth-dialog-save").on('click', function(){
				var id = $("#i-auth-dialog input[name='id']").val();
				var docLevel = $("#i-auth-dialog input[name='docLevel']").val();
				var kssLevel = $("#i-auth-dialog input[name='kssLevel']").val();
				var appType = $("#i-auth-dialog input[name='appType']").val()||"";
				var admType = $("#i-auth-dialog input[name='admType']").val();
				var isAudit=0
				if($("#i-auth-dialog input[name='isAudit']").is(':checked')){
					isAudit=1
				};
				if (!!!appType) {
					layer.alert("�������Ͳ���Ϊ�գ�лл...", {title:'��ʾ',icon: 0}); 
					return false;
				};
				var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","UpdateDHCCarPrvTpPHPoison", id, kssLevel, appType, admType, isAudit);
				if (rtn != "0") {
					layer.alert("�޸�ʧ��...", {title:'��ʾ',icon: 2}); 
					return false;
				} 
				layer.alert("�޸ĳɹ�...", {title:'��ʾ',icon: 1}); 
				$('#i-auth-dialog').window('close');
				reloadAuthGrid();
				
			});
			
		};
		
	});
	
	//�޸�ҽ��Ȩ��
	$("#i-auth-docAuthUpdate").on('click', function(){
		var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected){
			if (docAuthNum == 3) {
				var docdialogStr = "<div id='i-auth-docdialog-add' class='c-auth-docdialog-new container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<div class='col-xs-6'><span class='c-span'>ҽ������ </span><input id='i-9docAuth-docLevel' type='text'/></div>" +
								"<div class='col-xs-6'><span class='c-span'>ҽ������ </span><input id='i-9docAuth-doc' type='text' /></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>Ȩ��</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>�����Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS1-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS1-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS2-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS2-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���⼶</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS3-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS3-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-12' style='text-align:center;'><a id='c-auth-docdialog-add-save' class='btn btn-info c-btn' style='width:100px;'>����</a></div>" +
							"</div>" +
					"</div>";
					
				var $docdialog = $(docdialogStr);
				$("#i-auth-container").append($docdialog);
				$("#i-auth-docdialog-add input[type='checkbox']").iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});
				init9AuthDocBaseInfo();
				draw9AuthDocDialog();
				set9AuthDocVerify();
			} else if (docAuthNum == 9) {
				var docdialogStr = "<div id='i-auth-docdialog-add' class='c-auth-docdialog-new container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<div class='col-xs-6'><span class='c-span'>ҽ������ </span><input id='i-9docAuth-docLevel' type='text'/></div>" +
								"<div class='col-xs-6'><span class='c-span'>ҽ������ </span><input id='i-9docAuth-doc' type='text' /></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>����</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>�����Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-OKSS1-control' type='text' /></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-OKSS1-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-OKSS2-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-OKSS2-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���⼶</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-OKSS3-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-OKSS3-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>����</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>�����Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-EKSS1-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-EKSS1-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-EKSS2-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-EKSS2-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���⼶</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-EKSS3-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-EKSS3-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>סԺ</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>�����Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS1-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS1-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS2-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS2-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���⼶</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS3-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS3-verify' type='checkbox'/></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-12' style='text-align:center;'><a id='c-auth-docdialog-add-save' class='btn btn-info c-btn' style='width:100px;'>����</a></div>" +
							"</div>" +
					"</div>";
					
				var $docdialog = $(docdialogStr);
				$("#i-auth-container").append($docdialog);
				$("#i-auth-docdialog-add input[type='checkbox']").iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});
				init9AuthDocBaseInfo();
				draw9AuthDocDialog();
				set9AuthDocVerify();
			} else {
				var docdialogStr = "<div id='i-auth-docdialog-add' class='c-auth-docdialog container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>ҽ������</span><input id='i-auth-docdialog-add-docLevel' type='text' name='docLevel' /></div>" +
								"<div class='col-xs-6'><span class='c-span'>ҽ������</span><input id='i-auth-docdialog-add-docname' type='text' name='docName' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-auth-docdialog-add-kssLevel' type='text' name='kssLevel' /></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-auth-docdialog-add-admType' type='text' name='admType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-auth-docdialog-add-appType' type='text' name='appType' /></div>" +
								"<div class='col-xs-6'><span class='c-span'>���Ȩ��</span><input id='i-auth-docdialog-add-isAudit' type='checkbox' name='isAudit' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-12' style='text-align:center;'><a id='c-auth-docdialog-add-save' class='btn btn-info c-btn' style='width:100px;'>����</a></div>" +
							"</div>" +
					"</div>";
				var $docdialog = $(docdialogStr);
				$("#i-auth-container").append($docdialog);
				$("#i-auth-docdialog-add input[type='checkbox']").iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});
				drawAuthDocDialog("i-auth-docdialog-add", "", "");
				$("#i-auth-docdialog-add input[name='itemId']").val("");
				$("#i-auth-docdialog-add-docname").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-docLevel").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-admType").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-kssLevel").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-appType").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-isAudit").iCheck('uncheck'); 
			};
			
			$('#i-auth-docdialog-add').window({
				title: '���ҽ��Ȩ��', 
				iconCls:'fa fa-plus-circle',
				modal: true,
				minimizable:false,
				maximizable:false,
				collapsible:false,
				onClose: function () {
					$("#i-auth-docdialog-add").window('destroy');
					$docdialog.remove();
				}
			});
			
			$("#c-auth-docdialog-add-save").on('click', function(){
				if (docAuthNum == 1) {
					var id = $("#i-auth-docdialog-add input[name='itemId']").val();
					var docName = $("#i-auth-docdialog-add-docname").simplecombobox("getValue")||"";
					var docLevel = $("#i-auth-docdialog-add-docLevel").simplecombobox("getValue")||"";
					var kssLevel = $("#i-auth-docdialog-add-kssLevel").simplecombobox("getValue")||"";
					var appType = $("#i-auth-docdialog-add-appType").simplecombobox("getValue")||"";
					var admType = $("#i-auth-docdialog-add-admType").simplecombobox("getValue")||"";
					var isAudit=0
					if($("#i-auth-docdialog-add input[name='isAudit']").is(':checked')){
						isAudit=1
					};
					var tempFlag = (!!docLevel)&&(!!docName)&&(!!kssLevel)&&(!!appType)&&(!!admType);
					if (!tempFlag) {
						layer.alert("����д�ñ����ֶ�...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					
					var paraStr = id + "^" + docName + "^" + docLevel + "^" + kssLevel + "^" + appType + "^" + admType + "^" + isAudit + "^";
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateAuthItemNew", paraStr);
					if (rtn == "-201") {
						layer.alert("��ά������ҽ������...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					if (rtn == "-202") {
						layer.alert("û��ά����������...", {title:'��ʾ',icon: 0});
						return false;
					};
					layer.alert("��ӳɹ�...", {title:'��ʾ',icon: 1}); 
					$('#i-auth-docdialog-add').window('close');
					reloadAuthGrid();
				} else {
					var docLevel = $("#i-9docAuth-docLevel").simplecombobox('getValue')||"",
						doc = $("#i-9docAuth-doc").simplecombobox('getValue')||"";
					if ((!!!docLevel) || (!!!doc)) {
						layer.alert("ҽ�������ҽ������Ϊ��...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					var paraStr = build9DocAuthInfo(docAuthNum,"add9DocAuth");
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdate9DocAuth", paraStr);
					if (rtn == "-201") {
						layer.alert("��ά������ҽ������...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					if (rtn == "-202") {
						layer.alert("û��ά����������...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					layer.alert("��ӳɹ�...", {title:'��ʾ',icon: 1}); 
					$('#i-auth-docdialog-add').window('close');
					reloadAuthGrid();
					
				}
			});
			
		} else {
			if (selected.ctDocId == "") {
				layer.alert("����ҽ��Ȩ�޼�¼�������޸�...", {title:'��ʾ',icon: 5}); 
				return false;
			};
			if (selected.tppPoisonDr == "") {
				var mcgId = selected.id,
					docId = selected.ctDocId,
					prescAuth = 1;
				
				layer.confirm("��ȷ�Ϸſ���ҽ����������Ȩô��", {icon: 3, title:'��ʾ'}, function(index){
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth);
					if (rtn == "-2") {
						$.messager.alert('��ʾ','����ʧ�ܣ���Ϊ���ô���Ϊ��...','info');
						return false;
					};
					if (rtn == "-1") {
						$.messager.alert('��ʾ','����ʧ�ܣ���Ϊ���ô����Ѵ���...','info');
						return false;
					};
					layer.alert("���ĳɹ�...", {title:'��ʾ',icon: 1}); 
					reloadAuthGrid();
					layer.close(index);
				});
				/*
				$.messager.confirm('��ʾ', '��ȷ�Ϸſ���ҽ����������Ȩô��', function(r){
					if (r){
						var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth);
						if (rtn == "-2") {
							$.messager.alert('��ʾ','����ʧ�ܣ���Ϊ���ô���Ϊ��...','info');
							return false;
						};
						if (rtn == "-1") {
							$.messager.alert('��ʾ','����ʧ�ܣ���Ϊ���ô����Ѵ���...','info');
							return false;
						};
						$.messager.alert('��ϲ','���ĳɹ�...','info');
						reloadAuthGrid();
					}
				});
				*/
				return true;
			};
			if (docAuthNum == 3) {
				var docAuthObj = ANT.DHC.get9DocAuth(selected.ctDocId);
				DOC9AUTHOBJ = docAuthObj;
				var docdialogStr = "<div id='i-auth-docdialog' class='c-auth-docdialog-new container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<div class='col-xs-4'><span>ҽ������" + selected.CTCPTDesc+ "</span></div>" +
								"<div class='col-xs-5'><span>ҽ��������" + selected.ctDocDesc + "</span></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-docLevel' type='hidden' value='" + selected.rowId + "' /></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-doc' type='hidden' value='" + selected.ctDocId + "' /></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>Ȩ��</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>�����Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS1-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS1-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-IKSS1-itemId' type='hidden' value='" + docAuthObj.IAuth.kss1ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS2-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS2-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-IKSS2-itemId' type='hidden' value='" + docAuthObj.IAuth.kss2ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���⼶</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS3-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS3-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-IKSS3-itemId' type='hidden' value='" + docAuthObj.IAuth.kss3ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-12' style='text-align:center;'><a id='c-auth-docdialog-save' class='btn btn-info c-btn' style='width:100px;'>����</a></div>" +
							"</div>" +
					"</div>";
					var $docdialog = $(docdialogStr);
					$("#i-auth-container").append($docdialog);
					$("#i-auth-docdialog input[type='checkbox']").iCheck({
						labelHover : false,
						cursor : true,
						checkboxClass : 'icheckbox_square-blue',
						radioClass : 'iradio_square-blue',
						increaseArea : '20%'
					});
					draw9AuthDocDialog(docAuthObj);
					set9AuthDocVerify(docAuthObj);
			} else if (docAuthNum == 9) {
				var docAuthObj = ANT.DHC.get9DocAuth(selected.ctDocId);
				DOC9AUTHOBJ = docAuthObj;
				var docdialogStr = "<div id='i-auth-docdialog' class='c-auth-docdialog-new container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<div class='col-xs-4'><span>ҽ������" + selected.CTCPTDesc+ "</span></div>" +
								"<div class='col-xs-5'><span>ҽ��������" + selected.ctDocDesc + "</span></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-docLevel' type='hidden' value='" + selected.rowId + "' /></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-doc' type='hidden' value='" + selected.ctDocId + "' /></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>����</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>�����Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-OKSS1-control' type='text' /></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-OKSS1-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-OKSS1-itemId' type='hidden' value='" + docAuthObj.OAuth.kss1ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-OKSS2-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-OKSS2-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-OKSS2-itemId' type='hidden' value='" + docAuthObj.OAuth.kss2ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���⼶</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-OKSS3-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-OKSS3-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-OKSS3-itemId' type='hidden' value='" + docAuthObj.OAuth.kss3ItemId + "' /></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>����</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>�����Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-EKSS1-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-EKSS1-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-EKSS1-itemId' type='hidden' value='" + docAuthObj.EAuth.kss1ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-EKSS2-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-EKSS2-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-EKSS2-itemId' type='hidden' value='" + docAuthObj.EAuth.kss2ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���⼶</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-EKSS3-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-EKSS3-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-EKSS3-itemId' type='hidden' value='" + docAuthObj.EAuth.kss3ItemId + "' /></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>סԺ</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>�����Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS1-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS1-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-IKSS1-itemId' type='hidden' value='" + docAuthObj.IAuth.kss1ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���Ƽ�</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS2-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS2-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-IKSS2-itemId' type='hidden' value='" + docAuthObj.IAuth.kss2ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-2'><span class='c-span'>���⼶</span></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-9docAuth-IKSS3-control' type='text'/></div>" +
								"<div class='col-xs-3'><span class='c-span'>���Ȩ��</span><input id='i-9docAuth-IKSS3-verify' type='checkbox'/></div>" +
								"<div class='col-xs-1'><input id='i-9docAuth-IKSS3-itemId' type='hidden' value='" + docAuthObj.IAuth.kss3ItemId + "' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-12' style='text-align:center;'><a id='c-auth-docdialog-save' class='btn btn-info c-btn' style='width:100px;'>����</a></div>" +
							"</div>" +
					"</div>";
					var $docdialog = $(docdialogStr);
					$("#i-auth-container").append($docdialog);
					$("#i-auth-docdialog input[type='checkbox']").iCheck({
						labelHover : false,
						cursor : true,
						checkboxClass : 'icheckbox_square-blue',
						radioClass : 'iradio_square-blue',
						increaseArea : '20%'
					});
					draw9AuthDocDialog(docAuthObj);
					set9AuthDocVerify(docAuthObj);
			} else {
				var docdialogStr = "<div id='i-auth-docdialog' class='c-auth-docdialog container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row'>"  +
								"<div class='col-xs-6'><span class='c-span'>ҽ������</span><input id='i-auth-docdialog-docLevel' type='text' name='docLevel'/></div>" +
								"<div class='col-xs-6'><span class='c-span'>ҽ������</span><input id='i-auth-docdialog-docname' type='text' name='docname' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-auth-docdialog-kssLevel' type='text' name='kssLevel' /></div>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-auth-docdialog-admType' type='text' name='admType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>��������</span><input id='i-auth-docdialog-appType' type='text' name='appType' /></div>" +
								"<div class='col-xs-6'><span class='c-span'>���Ȩ��</span><input id='i-auth-docdialog-isAudit' type='checkbox' name='isAudit' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-12' style='text-align:center;'><a id='c-auth-docdialog-save' class='btn btn-info c-btn' style='width:100px;'>����</a></div>" +
							"</div>" +
					"</div>";
					var $docdialog = $(docdialogStr);
					$("#i-auth-container").append($docdialog);
					$("#i-auth-docdialog input[type='checkbox']").iCheck({
						labelHover : false,
						cursor : true,
						checkboxClass : 'icheckbox_square-blue',
						radioClass : 'iradio_square-blue',
						increaseArea : '20%'
					});
					drawAuthDocDialog("i-auth-docdialog", selected.rowId, selected.tppControlType,selected.ctDocId);
					$("#i-auth-docdialog input[name='itemId']").val(selected.id);
					//$("#i-auth-docdialog-docname").simplecombobox("setValue", selected.ctDocId);
					//$("#i-auth-docdialog-docLevel").simplecombobox("setValue", selected.rowId);
					$("#i-auth-docdialog-admType").combobox("setValue", selected.tppEpisodeType);
					$("#i-auth-docdialog-kssLevel").simplecombobox("setValue", selected.tppPoisonDr);
					$("#i-auth-docdialog-appType").combobox("setValue", selected.tppControlType);
					if (selected.tppChkVerify == 1) {
						$("#i-auth-docdialog-isAudit").iCheck('check'); 
					} else {
						$("#i-auth-docdialog-isAudit").iCheck('uncheck'); 
					};
			};
			$('#i-auth-docdialog').window({
				iconCls:'fa fa-pencil',
				title: '�޸�ҽ��Ȩ��',
				modal: true,
				minimizable:false,
				maximizable:false,
				collapsible:false,
				onClose: function () {
					$("#i-auth-docdialog").window('destroy');
					$docdialog.remove();
				}
			});
			
			$("#c-auth-docdialog-save").on('click', function(){
				if (docAuthNum == 1) {
					var id = $("#i-auth-docdialog input[name='itemId']").val();	//�ֱ�ID
					var mainId="";
					var docName = $("#i-auth-docdialog-docname").simplecombobox("getValue");
					var docLevel = $("#i-auth-docdialog-docLevel").simplecombobox("getValue");
					var kssLevel = $("#i-auth-docdialog-kssLevel").simplecombobox("getValue");
					var appType = $("#i-auth-docdialog-appType").simplecombobox("getValue")||"";
					var admType = $("#i-auth-docdialog-admType").simplecombobox("getValue");
					var isAudit=0
					if($("#i-auth-docdialog input[name='isAudit']").is(':checked')){
						isAudit=1
					};
					if (!!!appType) {
						layer.alert("�������Ͳ���Ϊ�գ�лл...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					var mStry = id.match(/\|+/g);
					if (mStry.length == "1") {	//�����¼�������ӱ�
						mainId = id;
						id = "";
					}
					var paraStr = id + "^" + docName + "^" + docLevel + "^" + kssLevel + "^" + appType + "^" + admType + "^" + isAudit + "^" + mainId;
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateAuthItemNew", paraStr);
					
					if (rtn == "-201") {
						layer.alert("��ά������ҽ������...", {title:'��ʾ',icon: 0}); 
						return false;
					} 
					if (rtn == "-202") {
						layer.alert("û��ά����������...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					layer.alert("�޸ĳɹ�...", {title:'��ʾ',icon: 1}); 
					$('#i-auth-docdialog').window('close');
					reloadAuthGrid();
				} else {
					var paraStr = build9DocAuthInfo(docAuthNum,undefined,DOC9AUTHOBJ);
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdate9DocAuth", paraStr);
					if (rtn == "-201") {
						layer.alert("��ά������ҽ������...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					if (rtn == "-202") {
						layer.alert("û��ά����������...", {title:'��ʾ',icon: 0}); 
						return false;
					};
					layer.alert("�޸ĳɹ�...", {title:'��ʾ',icon: 1}); 
					$('#i-auth-docdialog').window('close');
					reloadAuthGrid();
				}
			});
			
		};
		
	});
	
	$("#i-auth-docdelete").on('click', function(){
		var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected){ 
			layer.alert("��ѡ��һ��ҽ����¼...", {title:'��ʾ',icon: 0}); 
			return false;
		};
		var itemId = selected.id, docId = selected.ctDocId;
		if (docId == "") {
			layer.alert("����ҽ��Ȩ�޼�¼������ɾ��...", {title:'��ʾ',icon: 5}); 
			return false;
		};
		var mStry = itemId.match(/\|+/g);
		if (!mStry) {	//����null
			layer.alert("����ɾ������Ϊ�޴���Ȩ����...", {title:'��ʾ',icon: 0}); 
			return false;
		}
		if (mStry.length != "2") {
			layer.alert("�����ӱ��¼������ɾ��...", {title:'��ʾ',icon: 0}); 
			return false;
		}
		var message = "��ȷ��ɾ����ҽ��Ȩ������ô��";
		
		layer.confirm(message, {icon: 3, title:'��ʾ'}, function(index){
			var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBDeleteCPTPCp", itemId);
				if (rtn != "0") {
					$.messager.alert('��ʾ','ɾ��ʧ��...','info');
					return false;
				};
			layer.alert("ɾ���ɹ�...", {title:'��ʾ',icon: 1}); 
			reloadAuthGrid();
			layer.close(index);
		});
		/*
		$.messager.confirm('��ʾ', message, function(r){
			if (r){
				var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBDeleteCPTPCp", itemId);
				if (rtn != "0") {
					$.messager.alert('��ʾ','ɾ��ʧ��...','info');
					return false;
				};
				$.messager.alert('��ϲ','ɾ���ɹ�...','info');
				reloadAuthGrid();
			}
		});
		*/
		return true;
				
	});
	
	$("#i-auth-docforbidden").on('click', function(){
		var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected){ 
			layer.alert("��ѡ��һ��ҽ����¼...", {title:'��ʾ',icon: 0}); 
			return false;
		};
		var mcgId = selected.id, prescAuth = selected.docAut, docId = selected.ctDocId;
		if (docId == "") {
			layer.alert("����ҽ��Ȩ�޼�¼�������޸�...", {title:'��ʾ',icon: 5}); 
			return false;
		}
		if (mcgId.indexOf("||") > 0 ) mcgId = "";
		if (prescAuth != "0") {	//1��"" ��ʾ��Ȩ��,��ʱҪ��ֹ
			prescAuth = 0; 
		} else {
			prescAuth = 1; 		//0��ʾ��Ȩ�ޣ���ʱҪ�ſ�
		}
		var message = "��ȷ�Ͻ�ֹ��ҽ�����п�������Ȩô��";
		if (prescAuth == "1") {
			message = "��ȷ�Ϸſ���ҽ����������Ȩô��";
		};
		
		layer.confirm(message, {icon: 3, title:'��ʾ'}, function(index){
			var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth);
			if (rtn == "-2") {
				layer.alert("����ʧ�ܣ���Ϊ���ô���Ϊ��...", {title:'��ʾ',icon: 0}); 
				return false;
			};
			if (rtn == "-1") {
				layer.alert("����ʧ�ܣ���Ϊ���ô����Ѵ���...", {title:'��ʾ',icon: 0}); 
				return false;
			};
			layer.alert("���ĳɹ�...", {title:'��ʾ',icon: 1}); 
			reloadAuthGrid();
			layer.close(index);
		});
		
		/*
		$.messager.confirm('��ʾ', message, function(r){
			if (r){
				var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth);
				if (rtn == "-2") {
					$.messager.alert('��ʾ','����ʧ�ܣ���Ϊ���ô���Ϊ��...','info');
					return false;
				};
				if (rtn == "-1") {
					$.messager.alert('��ʾ','����ʧ�ܣ���Ϊ���ô����Ѵ���...','info');
					return false;
				};
				//$.messager.alert('��ʾ','���ĳɹ�...','info');
				layer.alert("���ĳɹ�...", {
					title:'��ʾ',
					icon: 1
				}); 
				reloadAuthGrid();
			}
		});
		*/	
		return true;
	});
	
	$("#i-auth-import").on('click', function(){
		if ( !ANT.IESupport(browserType) ){
			return false;
		};
		var $fileOBJ = $("#i-file");
		$fileOBJ.val("");
		if ($fileOBJ.length > 0) {
			$fileOBJ.get(0).click();
		} else {
			layer.alert("��ѡ���ļ�...", {title:'��ʾ',icon: 0}); 
			return false;
		}
		var filePath = $fileOBJ.val();
		if ((filePath =="")||(!filePath)){
			return false;
		}
		MaskUtil.mask("���ڵ��룬���Եȡ�����");
        window.setTimeout(function () {
            ANT.parseExcel({
				filePath: filePath,
				className: "DHCAnt.KSS.Config.Authority",
				method: "ImportExcel",
				MaskUtil: MaskUtil
			});
        },100);
		
		return false;
	});
	
	$("#i-auth-clear").on("click", function () {
		$("#i-auth-condition-switch").iCheck('uncheck'); 
		$("#i-auth-condition-verifyAuth").iCheck('uncheck'); 
		$("#i-auth-condition-prescAuth").iCheck('uncheck'); 
		$("#i-auth-condition-docLevel").simplecombobox("setValue","");
		$("#i-auth-condition-loc").simplecombobox("setValue","");
		$("#i-auth-condition-docname").simplecombobox("setValue","");
		$("#i-auth-condition-docnum").val("");
		$("#i-auth-condition-admType").simplecombobox("setValue","");
		$("#i-auth-condition-kssLevel").simplecombobox("setValue","");
		
		$('#i-auth-condition-docname').simplecombobox({
			onBeforeLoad: function(param){
				param.ClassName="DHCAnt.KSS.Config.Authority";
				param.QueryName="QryDoctor";
				param.ModuleName="combobox";
				param.Arg1="";
				param.Arg2="";
				param.ArgCnt=2;
			}
		});
		//����HISUIBUG QP 2018-04-28
		//ANT.DHC.setHUICombo(browserType);
		reloadAuthGrid();
	});
	$("#i-auth-condition-docnum").keydown(function (event) {
		if (event.which == 13 || event.which == 9) {
			reloadAuthGrid();
		}
	});
	
	window.reloadAuthGrid = function() {
		var arg1="",arg2="",arg3="",
			arg4="",arg5="",arg6="",
			arg7="",arg8="",arg9="";
		if(!$("#i-auth-condition-switch").is(':checked')){
			arg2=$("#i-auth-condition-loc").simplecombobox('getValue')||"";	//����id
			arg3=$("#i-auth-condition-docLevel").simplecombobox('getValue')||"";	//ҽ������
			arg4=$("#i-auth-condition-docname").simplecombobox('getValue')||"";	//ҽ��id
			arg5=$("#i-auth-condition-docnum").val();	//ҽ������
			arg6=$("#i-auth-condition-admType").simplecombobox('getValue')||"";	//��������
			arg7=$("#i-auth-condition-kssLevel").simplecombobox('getValue')||"";	//����ҩ�Ｖ��
			
			if($("#i-auth-condition-prescAuth").is(':checked')){
				arg8=1	//ҽʦ����Ȩ
			};
			if($("#i-auth-condition-verifyAuth").is(':checked')){
				arg9=1;	//���Ȩ��
			};
		} else {
			arg1=1;
			arg3=$("#i-auth-condition-docLevel").simplecombobox('getValue')||"";	//ҽ������
			arg6=$("#i-auth-condition-admType").simplecombobox('getValue')||"";	//��������
			arg7=$("#i-auth-condition-kssLevel").simplecombobox('getValue')||"";	//����ҩ�Ｖ��
			if($("#i-auth-condition-verifyAuth").is(':checked')){
				arg9=1;	//���Ȩ��
			};
		};
		if ((arg2 == "") && (arg3 == "") && (arg4 == "") && (arg5 == "") && (arg6 == "") && (arg7 == "")&& (arg8 == "") && (arg9 == "")) {
			arg1 = 1;
		}
		if (arg9 == 1) {
			if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
				layer.alert("��ѡ��Ȩ�����͡�ҽ�����𡢿��ҡ�ҽ���򹤺�������һ���ٽ��в�ѯ��лл...", {title:'��ʾ',icon: 0}); 
				return false;
			}
		}
		if (arg6 != "") {
			if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
				layer.alert("��ѡ��Ȩ�����͡�ҽ�����𡢿��ҡ�ҽ���򹤺�������һ���ٽ��в�ѯ��лл...", {title:'��ʾ',icon: 0}); 
				return false;
			}
		}
		if (arg7 != "") {
			if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
				layer.alert("��ѡ��Ȩ�����͡�ҽ�����𡢿��ҡ�ҽ���򹤺�������һ���ٽ��в�ѯ��лл...", {title:'��ʾ',icon: 0}); 
				return false;
			}
		}
		$('#i-auth-grid').simpledatagrid("clearSelections");
		$('#i-auth-grid').simpledatagrid("reload",{
			ClassName:"DHCAnt.KSS.Config.Authority",
			QueryName:"QryKSSAuthority",
			ModuleName:"datagrid",
			Arg1:arg1,Arg2:arg2,Arg3:arg3,
			Arg4:arg4,Arg5:arg5,Arg6:arg6,
			Arg7:arg7,Arg8:arg8,Arg9:arg9,
			ArgCnt:9
		});
	};
	
	function banBackSpace(e){
		var ev = e || window.event;
		var obj = ev.relatedTarget || ev.srcElement || ev.target ||ev.currentTarget;
		if(ev.keyCode == 8){
			var tagName = obj.nodeName;
			if(tagName!='INPUT' && tagName!='TEXTAREA'){
				return stopIt(ev);
			}
			var tagType = obj.type.toUpperCase();
			if(tagName=='INPUT' && (tagType!='TEXT' && tagType!='TEXTAREA' && tagType!='PASSWORD')){
				return stopIt(ev);
			}
			if((tagName=='INPUT' || tagName=='TEXTAREA') && (obj.readOnly==true || obj.disabled ==true)){
				return stopIt(ev);
			}
		}
	}
	function stopIt(ev){
		if(ev.preventDefault ){
			ev.preventDefault();
		}
		if(ev.returnValue){
			ev.returnValue = false;
		}
		return false;
	} 
	document.onkeypress = banBackSpace;
	document.onkeydown = banBackSpace;
})