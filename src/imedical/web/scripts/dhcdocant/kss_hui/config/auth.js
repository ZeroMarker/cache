/**
 * dhcant.kss.config.function.app.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
 
var PageLogicObj = {
	m_HospGrid:"",
	m_HospBox:"",
	m_CHosp:""
}
var docAuthNum = "";
$(function(){
	var browserType = ANT.getBrowserType(),
		//docAuthNum = "",	$.trim(ANT.DHC.getDocAuthNum()),
		DOC9AUTHOBJ,
		MaskUtil = ANT.initEasyUIMask();
		//ANT.initCheckboxSetting("input");
		//ANT.initCheckboxSetting("#i-auth-dialog-add input");
		//ANT.setComboWidth(browserType,"i-auth-condition-docnum");
	InitHospList();
	
	var columns = [[
			//{field:'ck',checkbox:false},
			{field:'CTCPTDesc',title:'医护级别',width:100},
			{field:'ctDocDesc',title:'医生',width:100},
			{field:'tppEpisodeType',title:'就诊类型',width:100,
				formatter: function(value,row,index){
					if (row.tppEpisodeType == "I"){
						return "<span style='color:#337AB7;'>住院</span>";
					} else if (row.tppEpisodeType == "E") {
						return "<span style='color:red;'>急诊</span>";
					} else if (row.tppEpisodeType == "O") {
						return "<span style='color:green;'>门诊</span>";
					} else {
						return value;
					}
				}
			},
			{field:'phcpoDesc',title:'抗菌药物级别',width:200},
			{field:'tppControlTypeDesc',title:'允许类型',width:100},
			{field:'isKssAut',title:'是否维医生权限',width:110,
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>";
					} else if (value == "0") {
						return "<span class='c-no'>否</span>";
					} else {
						return value;
					}
				}
			},	//是否权限到医生
			{field:'docAut',title:'医生处方权',width:100,hidden:true},
			{field:'tppChkVerify',title:'有无审核权限',width:100,
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>有</span>";
					} else if (value == "0") {
						return "<span class='c-no'>无</span>";
					} else {
						return value;
					}
				}
			},
			{field:'DateFrom',title:'开始日期',width:100
				/*,formatter:function(v,r,i){
					if(v  == ""){
						$('#i-auth-grid').simpledatagrid("hideColumn","DateFrom");
						//$('td[field="DateFrom"]').hide();
					}else{
						$('#i-auth-grid').simpledatagrid("showColumn","DateFrom");
						//$('td[field="DateFrom"]').show();
						return v;
						
					}
				}*/
			},
			{field:'DateTo',title:'截止日期',width:100
				/*,formatter:function(v,r,i){
					if(v == ""){
						$('#i-auth-grid').datagrid("hideColumn","DateTo");
						//$('td[field="DateTo"]').hide();
					}else{
						$('#i-auth-grid').datagrid("showColumn","DateTo");
						//$('td[field="DateTo"]').show();
						return v;
						
					}
				}*/
			},
			{field:'hospDesc',title:'院区',width:200},
			{field:'hospId',title:'hospId',width:100,hidden:true},
			{field:'id',title:'表ID',width:100,hidden:true},
			{field:'rowId',title:'医护级别ID',width:100,hidden:true},
			{field:'ctDocId',title:'医生ID',width:100,hidden:true},
			{field:'tppPoisonDr',title:'抗菌药物级别ID',width:100,hidden:true}
		]];
		
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
		rownumbers:false,
		onBeforeSelect:function(index, row){
			var selrow=$("#i-auth-grid").datagrid('getSelected');
			if (selrow){
				var oldIndex=$("#i-auth-grid").datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					$("#i-auth-grid").datagrid('unselectRow',index);
					return false;
				}
			}
		},
		frozenColumns:[
			{field:'ck',checkbox:false}
		],
		toolbar:[
				{
						text:'新增级别权限',
						id:'i-auth-levelAuthAdd',
						iconCls: 'icon-add',
						handler: function(){
							
						}
				},
				{
						text:'修改级别权限允许类型与审核权限',
						id:'i-auth-levelAuthUpdate',
						iconCls: 'icon-levelauth',
						handler: function(){
						}
				},'-',{
						text:'新增医生权限',
						id:'i-auth-docAuthAdd',
						iconCls: 'icon-doctor',
						handler: function(){
						}
				},
				{
						text:'修改医生权限允许类型与审核权限',
						id:'i-auth-docAuthUpdate',
						iconCls: 'icon-docauth',
						handler: function(){
						}
				},
				{
						text:'删除医生权限',
						id:'i-auth-docdelete',
						iconCls: 'icon-deleteauth',
						handler: function(){
						}
						
				},'-',{
						text:'更改处方权',
						id:'i-auth-docforbidden',
						iconCls: 'icon-antpresc',
						handler: function(){
						}
				}
					
		],
		//className:"DHCAnt.KSS.Config.Authority",
		//queryName:"QryKSSAuthority"
		columns:columns
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
					//$html='<input class="hisui-checkbox" type="checkbox" label="已就诊">';
					//$("#i-auth-container .datagrid-row[datagrid-row-index=" + i + "]").find(".datagrid-cell-check").remove();
					//$("#i-auth-container .datagrid-row[datagrid-row-index=" + i + "] td[field='ck']").append($html);
				};
			};
		}*/
	});
	
	//$('#i-auth-grid').datagrid("hideColumn","DateFrom");
	//$('#i-auth-grid').datagrid("hideColumn","DateTo");
	
	//所属院区
	/* $('#i-auth-condition-hosp').simplecombobox({
		blurValidValue:true,
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryHosp";
			param.ModuleName="combobox";
			param.ArgCnt=0;
		}
	}); */
	
	//医护级别Combox
	$('#i-auth-condition-docLevel').simplecombobox({
		blurValidValue:true,
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryDoctorLevl";
			param.ModuleName="combobox";
			param.ArgCnt=0;
		},
		onChange: function (newValue, oldValue) {
			if (newValue == undefined) {
				flushDoc("");
			}
		},
		onSelect:function(record) {
			flushDoc(record.id);
		},
		onUnselect: function () {
			$(this).simplecombobox('setValue', '');
			flushDoc("");
		}
	});
	
	
	//医生科室Combox
	$('#i-auth-condition-loc').simplecombobox({
		blurValidValue:true,
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryGetdep";
			param.ModuleName="combobox";
			param.Arg1="";
			param.Arg2=GetHospValue();
			param.ArgCnt=2;
		},
		editable:true,
		onChange: function (newValue, oldValue) {
			//console.log(newValue + ": " + oldValue);
			if (newValue == undefined) {
				
				flushDoc("", "");
			}
		},
		onSelect:function(record) {
			flushDoc("", record.id)
		},
		onUnselect: function () {
			$(this).simplecombobox('setValue', '');
			flushDoc("", "");
		}
	});
	//就诊类型Combox
	$('#i-auth-condition-admType').localcombobox({
		blurValidValue:true,
		data: [{id: 'O', text: '门诊'}, {id: 'E',text: '急诊'}, {id: 'I',text: '住院'}]
	});
	//抗菌级别Combox
	$('#i-auth-condition-kssLevel').simplecombobox({
		blurValidValue:true,
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryKSSLevl";
			param.ModuleName="combobox";
			param.Arg1=PageLogicObj.m_CHosp;
			param.ArgCnt=1;
		}
	});
	//医生姓名Combox
	$('#i-auth-condition-docname').simplecombobox({
		blurValidValue:true,
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryDoctor";
			param.ModuleName="combobox";
			param.Arg1="";
			param.Arg2="";
			param.Arg3="";
			param.Arg4=GetHospValue();
			param.ArgCnt=4;
		}
	});
	
	//HISUI库不支持ifChecked和ifUnchecked,很无语
	$("#i-auth-condition-switch").checkbox({
		onChecked: function () {
			if ($("#i-auth-condition-prescAuth").is(':checked')) {
				$("#i-auth-condition-prescAuth").checkbox('uncheck'); 
			};
			$("#i-auth-condition-loc").simplecombobox("setValue","");
			$("#i-auth-condition-docname").simplecombobox("setValue","");
			$("#i-auth-condition-docnum").val("");
			$("#i-auth-condition-loc").simplecombobox("disable");
			$("#i-auth-condition-docname").simplecombobox("disable");
			$("#i-auth-condition-docnum").attr("disabled","disabled");
		},
		onUnchecked: function () {
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
					param.Arg3 = "";
					param.Arg4 = GetHospValue();
					param.ArgCnt=4;
				}
			});
			//处理HISUIBUG QP 2018-04-28
			//ANT.DHC.setHUICombo(browserType);
		}
	})
	
	$("#i-auth-condition-prescAuth").checkbox({
		onChecked: function (e,value) {
			//$('#i-auth-grid').datagrid("showColumn","DateFrom");
			//$('#i-auth-grid').datagrid("showColumn","DateTo");
			/*$('#i-auth-grid').simpledatagrid({
				columns:columns
			})*/
			$("#i-auth-condition-switch").checkbox('uncheck'); 
			$("#i-auth-condition-verifyAuth").checkbox('uncheck'); 
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
					param.Arg3="";
					param.Arg4=GetHospValue();
					param.ArgCnt=4;
				}
			});
			//处理HISUIBUG QP 2018-04-28
			//ANT.DHC.setHUICombo(browserType);
			reloadAuthGrid();
		},
		onUnchecked: function (e,value) {
			//$('#i-auth-grid').datagrid("hideColumn","DateFrom");
			//$('#i-auth-grid').datagrid("hideColumn","DateTo");
			$("#i-auth-condition-docLevel").simplecombobox("enable");
			$("#i-auth-condition-loc").simplecombobox("enable");
			$("#i-auth-condition-docname").simplecombobox("enable");
			$("#i-auth-condition-docnum").removeAttr("disabled");
			$("#i-auth-condition-admType").localcombobox("enable");
			$("#i-auth-condition-kssLevel").simplecombobox("enable");
			reloadAuthGrid();
		}
	});
	
	$("#i-auth-condition-verifyAuth").checkbox({
		onChecked: function () {
			$("#i-auth-condition-prescAuth").checkbox('uncheck'); 
		}
	});
	
	$("#i-auth-find").on('click', function(){
		reloadAuthGrid();
	});
	
	function drawAuthDialog(selector, admType, appType){
		if (selector == "i-auth-dialog") {	//修改
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
				data: [{id: 'O', text: '门诊'}, {id: 'E',text: '急诊'}, {id: 'I',text: '住院'}],
				value: admType
			});
			
			$("#" + selector + " input[name='kssLevel']").simplecombobox({
				disabled: true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryKSSLevl";
					param.ModuleName="combobox";
					param.Arg1=PageLogicObj.m_CHosp;
					param.ArgCnt=1;
				}
			});
			
			$("#" + selector + " input[name='hosp']").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryHosp";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
			
			$("#" + selector + "-appType").localcombobox({
				required:true,
				data: [{id: 'A', text: '提示'}, {id: 'P',text: '申请单'}, {id: 'E',text: '越级'}, {id: 'F',text: '禁止'}],
				value: appType
			});
			$("#i-auth-dialog-ck").checkbox();
			$("#i-auth-dialog-save").linkbutton({
				iconCls:'icon-w-save'
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
				data: [{id: 'O', text: '门诊'}, {id: 'E',text: '急诊'}, {id: 'I',text: '住院'}],
				value: admType
			});
			
			$("#" + selector + " input[name='kssLevel']").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryKSSLevl";
					param.ModuleName="combobox";
					param.Arg1=PageLogicObj.m_CHosp;
					param.ArgCnt=1;
				}
			});
			
			$("#" + selector + " input[name='hosp']").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryHosp";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},
				value:PageLogicObj.m_CHosp
			});
			
		
		}
		
		$("#" + selector + " input[name='appType']").localcombobox({
			required:true,
			data: [{id: 'A', text: '提示'}, {id: 'P',text: '申请单'}, {id: 'E',text: '越级'}, {id: 'F',text: '禁止'}],
			value: appType
		});
		$("#i-auth-dialog-add-ck").checkbox();
		$("#i-auth-dialog-add-save").linkbutton({
			iconCls:'icon-w-save'
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
		
		//权限
		if (docAuthNum == 3) {
			OKSS1Control = EKSS1Control = IKSS1Control = $("#i-9docAuth-IKSS1-control").localcombobox('getValue')||"";
			OKSS2Control = EKSS2Control = IKSS2Control = $("#i-9docAuth-IKSS2-control").localcombobox('getValue')||"";
			OKSS3Control = EKSS3Control = IKSS3Control = $("#i-9docAuth-IKSS3-control").localcombobox('getValue')||"";
		};
		if (docAuthNum == 9) {
			OKSS1Control = $("#i-9docAuth-OKSS1-control").localcombobox('getValue')||"";
			OKSS2Control = $("#i-9docAuth-OKSS2-control").localcombobox('getValue')||"";
			OKSS3Control = $("#i-9docAuth-OKSS3-control").localcombobox('getValue')||"";
		
			EKSS1Control = $("#i-9docAuth-EKSS1-control").localcombobox('getValue')||"";
			EKSS2Control = $("#i-9docAuth-EKSS2-control").localcombobox('getValue')||"";
			EKSS3Control = $("#i-9docAuth-EKSS3-control").localcombobox('getValue');
		
			IKSS1Control = $("#i-9docAuth-IKSS1-control").localcombobox('getValue')||"";
			IKSS2Control = $("#i-9docAuth-IKSS2-control").localcombobox('getValue')||"";
			IKSS3Control = $("#i-9docAuth-IKSS3-control").localcombobox('getValue')||"";
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
			
			//门诊id处理
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
			//急诊id处理
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
			//住院id处理
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
			//住院verify
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
			//门诊verify
			if($("#i-9docAuth-OKSS1-verify").is(':checked')) {
				OKSS1Verify = 1;
			};
			if($("#i-9docAuth-OKSS2-verify").is(':checked')) {
				OKSS2Verify = 1;
			};
			if($("#i-9docAuth-OKSS3-verify").is(':checked')) {
				OKSS3Verify = 1;
			};
			//急诊verify
			if($("#i-9docAuth-EKSS1-verify").is(':checked')) {
				EKSS1Verify = 1;
			};
			if($("#i-9docAuth-EKSS2-verify").is(':checked')) {
				EKSS2Verify = 1;
			};
			if($("#i-9docAuth-EKSS3-verify").is(':checked')) {
				EKSS3Verify = 1;
			};
			//住院verify
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
		
		if ((!!OKSS1Control)||(OKSS1Verify==1))  {
			if (mRtn == "")  {mRtn = OKSS1Info;}
			else { mRtn = mRtn + FG2 + OKSS1Info;}
		}
		if ((!!OKSS2Control)||(OKSS2Verify==1))  {
			if (mRtn == "")  {mRtn = OKSS2Info;}
			else { mRtn = mRtn + FG2 + OKSS2Info;}
		}
		if ((!!OKSS3Control)||(OKSS3Verify==1))  {
			if (mRtn == "")  {mRtn = OKSS3Info;}
			else { mRtn = mRtn + FG2 + OKSS3Info;}
		}
		
		//
		if ((!!EKSS1Control)||(EKSS1Verify==1))  {
			if (mRtn == "")  {mRtn = EKSS1Info;}
			else { mRtn = mRtn + FG2 + EKSS1Info;}
		}
		if ((!!EKSS2Control)||(EKSS2Verify==1))  {
			if (mRtn == "")  {mRtn = EKSS2Info;}
			else { mRtn = mRtn + FG2 + EKSS2Info;}
		}
		if ((!!EKSS3Control)||(EKSS3Verify==1))  {
			if (mRtn == "")  {mRtn = EKSS3Info;}
			else { mRtn = mRtn + FG2 + EKSS3Info;}
		}
		
		//
		if ((!!IKSS1Control)||(IKSS1Verify==1))  {
			if (mRtn == "")  {mRtn = IKSS1Info;}
			else { mRtn = mRtn + FG2 + IKSS1Info;}
		}
		if ((!!IKSS2Control)||(IKSS2Verify==1))  {
			if (mRtn == "")  {mRtn = IKSS2Info;}
			else { mRtn = mRtn + FG2 + IKSS2Info;}
		}
		if ((!!IKSS3Control)||(IKSS3Verify==1))  {
			if (mRtn == "")  {mRtn = IKSS3Info;}
			else { mRtn = mRtn + FG2 + IKSS3Info;}
		}
		
		return mRtn;
	};
	
	function set9AuthDocVerify(docAuthObj) {
		if (!!docAuthObj) {
			//门诊
			if (docAuthObj.OAuth.kss1Verify == "Y") {
				$("#i-9docAuth-OKSS1-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-OKSS1-verify").checkbox('uncheck'); 
			};
			
			if (docAuthObj.OAuth.kss2Verify == "Y") {
				$("#i-9docAuth-OKSS2-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-OKSS2-verify").checkbox('uncheck'); 
			};
			
			if (docAuthObj.OAuth.kss3Verify == "Y") {
				$("#i-9docAuth-OKSS3-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-OKSS3-verify").checkbox('uncheck'); 
			};
			
			//急诊
			if (docAuthObj.EAuth.kss1Verify == "Y") {
				$("#i-9docAuth-EKSS1-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-EKSS1-verify").checkbox('uncheck'); 
			};
			
			if (docAuthObj.EAuth.kss2Verify == "Y") {
				$("#i-9docAuth-EKSS2-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-EKSS2-verify").checkbox('uncheck'); 
			};
			
			if (docAuthObj.EAuth.kss3Verify == "Y") {
				$("#i-9docAuth-EKSS3-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-EKSS3-verify").checkbox('uncheck'); 
			};
			
			//住院
			if (docAuthObj.IAuth.kss1Verify == "Y") {
				$("#i-9docAuth-IKSS1-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-IKSS1-verify").checkbox('uncheck'); 
			};
			
			if (docAuthObj.IAuth.kss2Verify == "Y") {
				$("#i-9docAuth-IKSS2-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-IKSS2-verify").checkbox('uncheck'); 
			};
			
			if (docAuthObj.IAuth.kss3Verify == "Y") {
				$("#i-9docAuth-IKSS3-verify").checkbox('check'); 
			} else {
				$("#i-9docAuth-IKSS3-verify").checkbox('uncheck'); 
			};
		} else {
			$("#i-9docAuth-OKSS1-verify").checkbox('uncheck'); 
			$("#i-9docAuth-OKSS2-verify").checkbox('uncheck');
			$("#i-9docAuth-OKSS3-verify").checkbox('uncheck'); 
			$("#i-9docAuth-EKSS1-verify").checkbox('uncheck'); 
			$("#i-9docAuth-EKSS2-verify").checkbox('uncheck'); 
			$("#i-9docAuth-EKSS3-verify").checkbox('uncheck'); 
			$("#i-9docAuth-IKSS1-verify").checkbox('uncheck'); 
			$("#i-9docAuth-IKSS2-verify").checkbox('uncheck'); 
			$("#i-9docAuth-IKSS3-verify").checkbox('uncheck'); 
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
						param.Arg3 = "";
						param.Arg4 = GetHospValue();
						param.ArgCnt=4;
					}
				});
				//ANT.DHC.setHCombo(browserType,"i-9docAuth-doc");
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
						param.Arg3 = "";
						param.Arg4 = GetHospValue();
						param.ArgCnt=4;
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
				param.Arg3="";
				param.Arg4=GetHospValue();
				param.ArgCnt=4;
			}
		});
		
		$("#i-9docAuth-hosp").simplecombobox({
			required:true,
			onBeforeLoad: function(param){
				param.ClassName="DHCAnt.KSS.Config.Authority";
				param.QueryName="QryHosp";
				param.ModuleName="combobox";
				param.ArgCnt=0;
			},
			value:PageLogicObj.m_CHosp
		});
	};
	
	function draw9AuthDocDialog(docAuthObj){
		var mData = [{id: 'A', text: '提示'}, {id: 'P',text: '申请单'}, 
					{id: 'E',text: '越级'}, {id: 'F',text: '禁止'}];
		
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
				data: [{id: 'O', text: '门诊'}, {id: 'E',text: '急诊'}, {id: 'I',text: '住院'}],
				value:admType
			});
			$("#" + selector + "-appType").localcombobox({
				required:true,
				data: [{id: 'A', text: '提示'}, {id: 'P',text: '申请单'}, {id: 'E',text: '越级'}, {id: 'F',text: '禁止'}],
				value: appType
			});
			
			$("#" + selector + " input[name='kssLevel']").simplecombobox({
				disabled: true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryKSSLevl";
					param.ModuleName="combobox";
					param.Arg1=PageLogicObj.m_CHosp;
					param.ArgCnt=1;
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
					param.Arg3="";
					param.Arg4=GetHospValue();
					param.ArgCnt=4;
				}
			});
			
			$("#i-auth-docdialog-hosp").simplecombobox({
				disabled: true,
				//value: doc,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryHosp";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			});
			
		} else {
			$("#" + selector + " input[name='admType']").localcombobox({
				required:true,
				data: [{id: 'O', text: '门诊'}, {id: 'E',text: '急诊'}, {id: 'I',text: '住院'}],
				value: admType
			});
			
			$("#" + selector + " input[name='kssLevel']").simplecombobox({
				required:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryKSSLevl";
					param.ModuleName="combobox";
					param.Arg1=PageLogicObj.m_CHosp;
					param.ArgCnt=1;
				}
			});
			
			$("#i-auth-docdialog-add-hosp").simplecombobox({
				required:true,
				//value: doc,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.Config.Authority";
					param.QueryName="QryHosp";
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
							param.Arg3 = "";
							param.Arg4 = GetHospValue();
							param.ArgCnt=4;
						}
					});
					//ANT.DHC.setHCombo(browserType,"i-auth-docdialog-add-docname");
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
							param.Arg3 = "";
							param.Arg4 = GetHospValue();
							param.ArgCnt=4;
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
					param.Arg3="";
					param.Arg4=GetHospValue();
					param.ArgCnt=4;
				}
			});
			
			$("#" + selector + " input[name='appType']").localcombobox({
				required:true,
				data: [{id: 'A', text: '提示'}, {id: 'P',text: '申请单'}, {id: 'E',text: '越级'}, {id: 'F',text: '禁止'}],
				value: appType
			});
		};
		
	};
	
	//修改级别权限
	$("#i-auth-levelAuthUpdate").on('click', function(){
		var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected) {
			layer.alert("请选择一条记录！", {
				title:'<i class="fa fa-hand-o-right" style="margin-right:4px;"></i>提示',
				icon: 0
			}); 
			return false;
		}
		editLevelAuth(selected)
	});
	
	$("#i-auth-levelAuthAdd").on('click', function(){
		editLevelAuth(undefined)
	});
	function editLevelAuth (selected) {
		//var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected){
			var dialogStr = "<div id='i-auth-dialog-add' class='c-auth-dialog container'>" +
							"<input type='hidden' name='id' />" +
							"<div class='row'>"  +
								"<div class='col-xs-6'><span class='c-span'>医护级别</span><input style='width:250px;' type='text' name='docLevel'/></div>" +
							"</div>" +
							"<div class='row'>"  +
								"<div class='col-xs-6'><span class='c-span'>就诊类型</span><input style='width:250px;' type='text' name='admType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>抗菌级别</span><input style='width:250px;' type='text' name='kssLevel' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>允许类型</span><input style='width:250px;' type='text' name='appType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>所属院区</span><input style='width:250px;' id='i-auth-dialog-add-hosp' type='text' name='hosp' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-ck-span'>审核权限</span><input id='i-auth-dialog-add-ck' type='checkbox' name='isAudit' /></div>" +
							"</div>" + 
							"<div class='row'>" +
								"<div class='col-xs-6'><span style='visibility:hidden;' class='c-span'>允许类型</span><a id='i-auth-dialog-add-save'>保存</a></div>" +
							"</div>" + 
					"</div>";
			var $dialogStr = $(dialogStr);
			$("#i-auth-container").append($dialogStr);
			/*
			$("#i-auth-dialog-add input[name='isAudit']").iCheck({
				labelHover : false,
				cursor : true,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});*/
			drawAuthDialog("i-auth-dialog-add", "", "");
			$("#i-auth-dialog-add input[name='id']").val("");
			$("#i-auth-dialog-add input[name='docLevel']").val("");
			$("#i-auth-dialog-add input[name='kssLevel']").val("");
			$("#i-auth-dialog-add input[name='appType']").val("");
			$("#i-auth-dialog-add input[name='admType']").val("");
			$("#i-auth-dialog-add input[name='isAudit']").checkbox('uncheck'); 
			
			$('#i-auth-dialog-add').window({
				title: '新增级别权限',
				modal: true,
				minimizable:false,
				iconCls:'icon-w-add',
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
				var hosp = $("#i-auth-dialog-add-hosp").combobox("getValue")||"";
				var isAudit=0
				
				if($("#i-auth-dialog-add input[name='isAudit']").is(':checked')){
					isAudit=1
				};
				var tempFlag = (!!docLevel)&&(!!kssLevel)&&(!!appType)&&(!!admType)&&(!!hosp)
				if (!tempFlag) {
					layer.alert("请填写好必填字段！", {title:'提示',icon: 0}); 
					return false;
				};
				var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","AddDHCCarPrvTpPHPoison", docLevel, kssLevel, appType, admType, isAudit, hosp);
				if (rtn == "-202") {
					layer.alert("表里已存在，不需要添加！", {title:'提示',icon: 0}); 
					return false;
				}
				if (rtn !="0") {
					layer.alert("添加失败！", {title:'提示',icon: 2}); 
					return false;
				}
				layer.alert("添加成功！", {title:'提示',icon: 1}); 
				$('#i-auth-dialog-add').window('close');
				reloadAuthGrid();

			});
			
			
		} else {
			if (selected.ctDocId != "") {
				//$.messager.alert('提示','不是医护级别记录，不能修改...','info');
				layer.alert("不是医护级别记录，不能修改！", {
					title:'<i class="fa fa-hand-o-right" style="margin-right:4px;"></i>提示',
					icon: 0
				}); 
				return false;
			}
			var domStr = "<div id='i-auth-dialog' class='c-auth-dialog container'>" +
							"<input type='hidden' name='id' />" +
							"<div class='row'>"  +
								"<div class='col-xs-6'><span class='c-span'>医护级别</span><input style='width:250px;'  type='text' name='docLevel'/></div>" +
							"</div>" +
							"<div class='row'>"  +
								"<div class='col-xs-6'><span class='c-span'>就诊类型</span><input style='width:250px;'  type='text' name='admType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>抗菌级别</span><input style='width:250px;'  type='text' name='kssLevel' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>允许类型</span><input style='width:250px;'  type='text' name='appType' id='i-auth-dialog-appType' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-span'>所属院区</span><input style='width:250px;'  id='i-auth-dialog-hosp' type='text' name='hosp' /></div>" +
							"</div>" +
							"<div class='row'>" +
								"<div class='col-xs-6'><span class='c-ck-span'>审核权限</span><input id='i-auth-dialog-ck' type='checkbox' name='isAudit' /></div>" +
							"</div>" + 
							"<div class='row'>" +
								"<div class='col-xs-6'><span style='visibility:hidden;' class='c-span'>允许类型</span><a id='i-auth-dialog-save'>保存</a></div>" +
							"</div>" + 
					"</div>";
			var $domStr = $(domStr);
			$("#i-auth-container").append($domStr);
			/*
			$("#i-auth-dialog input[name='isAudit']").iCheck({
				labelHover : false,
				cursor : true,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});*/
			drawAuthDialog("i-auth-dialog", selected.tppEpisodeType, selected.tppControlType);
			$("#i-auth-dialog input[name='id']").val(selected.id);	//主表id
			$("#i-auth-dialog input[name='docLevel']").val(selected.rowId);
			$("#i-auth-dialog input[name='kssLevel']").val(selected.tppPoisonDr).attr("disabled","disabled");
			//$("#i-auth-dialog input[name='appType']").val(selected.tppControlType);
			$("#i-auth-dialog-appType").combobox('setValue',selected.tppControlType);
			$("#i-auth-dialog-hosp").combobox('setValue',selected.hospId);
			$("#i-auth-dialog input[name='admType']").val(selected.tppEpisodeType).attr("disabled","disabled");
			if (selected.tppChkVerify == 1) {
				$("#i-auth-dialog input[name='isAudit']").checkbox('check'); 
			} else {
				$("#i-auth-dialog input[name='isAudit']").checkbox('uncheck'); 	//iCheck
			};
			
			$('#i-auth-dialog').window({
				title: '修改级别权限允许类型与审核权限',
				modal: true,
				iconCls:'icon-w-edit',
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
				var hosp = $("#i-auth-dialog-hosp").combobox("getValue")||"";
				
				var isAudit=0
				if($("#i-auth-dialog input[name='isAudit']").is(':checked')){
					isAudit=1
				};
				if (!!!appType) {
					layer.alert("允许类型不能为空，谢谢！", {title:'提示',icon: 0}); 
					return false;
				};
				if (!!!hosp) {
					layer.alert("院区不能为空，谢谢！", {title:'提示',icon: 0}); 
					return false;
				};
				var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","UpdateDHCCarPrvTpPHPoison", id, kssLevel, appType, admType, isAudit, hosp);
				if (rtn != "0") {
					layer.alert("修改失败！", {title:'提示',icon: 2}); 
					return false;
				} 
				layer.alert("修改成功！", {title:'提示',icon: 1}); 
				$('#i-auth-dialog').window('close');
				reloadAuthGrid(1);
				
			});
			
		};
	}
	InitCache();
	//修改医生权限
	$("#i-auth-docAuthAdd").on('click', function(){
		editDocAuth(undefined);
		return false;
		
	});
	$("#i-auth-docAuthUpdate").on('click', function(){
		var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected) {
			layer.alert("请选择一条医生记录！", {
				title:'<i class="fa fa-hand-o-right" style="margin-right:4px;"></i>提示',
				icon: 0
			}); 
			return false;
		}
		editDocAuth(selected);
		return false;
	});
	
	function editDocAuth (selected) {
		//var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected){
			if (docAuthNum == 3) {
				var docdialogStr = "<div id='i-auth-docdialog-add' class='c-auth-docdialog-new container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<span class='c-span'>医护级别</span><input id='i-9docAuth-docLevel' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>医生姓名</span><input id='i-9docAuth-doc' type='text' />" +
							"</div>" +
							"<div class='row'>" +
								"<div><span class='c-span'>所属院区</span><input style='width:407px;' id='i-9docAuth-hosp' type='text'/></div>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>权限</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>非限制</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS1-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS1-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>限制级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS2-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS2-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>特殊级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS3-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS3-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row' style='text-align:center;'>" +
								"<a id='c-auth-docdialog-add-save'>保存</a>" +
							"</div>" +
					"</div>";
					
				var $docdialog = $(docdialogStr);
				$("#i-auth-container").append($docdialog);
				/*
				$("#i-auth-docdialog-add input[type='checkbox']").iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});*/
				$("#c-auth-docdialog-add-save").linkbutton({
					iconCls:'icon-w-save'
				});
				
				$("#i-9docAuth-IKSS3-verify").checkbox();
				$("#i-9docAuth-IKSS2-verify").checkbox();
				$("#i-9docAuth-IKSS1-verify").checkbox();
				init9AuthDocBaseInfo();
				draw9AuthDocDialog();
				set9AuthDocVerify();
			} else if (docAuthNum == 9) {
				var docdialogStr = "<div id='i-auth-docdialog-add' class='c-auth-docdialog-new container' style='height:500px;'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<span class='c-span'>医护级别</span><input id='i-9docAuth-docLevel' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>医生姓名 </span><input id='i-9docAuth-doc' type='text' />" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<span class='c-span'>所属院区</span><input style='width:407px;' id='i-9docAuth-hosp' type='text'/>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>门诊</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>非限制</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-OKSS1-control' type='text' />" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-OKSS1-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>限制级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-OKSS2-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-OKSS2-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>特殊级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-OKSS3-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-OKSS3-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>急诊</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>非限制</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-EKSS1-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-EKSS1-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>限制级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-EKSS2-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-EKSS2-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>特殊级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-EKSS3-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-EKSS3-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>住院</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>非限制</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS1-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS1-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>限制级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS2-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS2-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>特殊级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS3-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS3-verify' type='checkbox'/>" +
							"</div>" +
							"<div class='row' style='text-align:center;'>" +
								"<a id='c-auth-docdialog-add-save' class='btn btn-info c-btn' style='width:100px;'>保存</a>" +
							"</div>" +
					"</div>";
					
				var $docdialog = $(docdialogStr);
				$("#i-auth-container").append($docdialog);
				/*
				$("#i-auth-docdialog-add input[type='checkbox']").iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});
				*/
				$("#c-auth-docdialog-add-save").linkbutton({
					iconCls:'icon-w-save'
				});
					
				$("#i-9docAuth-OKSS1-verify").checkbox();
				$("#i-9docAuth-OKSS2-verify").checkbox();
				$("#i-9docAuth-OKSS3-verify").checkbox();
				
				$("#i-9docAuth-EKSS1-verify").checkbox();
				$("#i-9docAuth-EKSS2-verify").checkbox();
				$("#i-9docAuth-EKSS3-verify").checkbox();
				
				$("#i-9docAuth-IKSS3-verify").checkbox();
				$("#i-9docAuth-IKSS2-verify").checkbox();
				$("#i-9docAuth-IKSS1-verify").checkbox();
				init9AuthDocBaseInfo();
				draw9AuthDocDialog();
				set9AuthDocVerify();
			} else {
				var docdialogStr = "<div id='i-auth-docdialog-add' class='c-auth-docdialog container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row'>" +
								"<span class='c-span'>医护级别</span><input id='i-auth-docdialog-add-docLevel' type='text' name='docLevel' />" +
								"<span class='c-span-sp'></span><span class='c-span'>医生姓名</span><input id='i-auth-docdialog-add-docname' type='text' name='docName' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>抗菌级别</span><input id='i-auth-docdialog-add-kssLevel' type='text' name='kssLevel' />" +
								"<span class='c-span-sp'></span><span class='c-span'>就诊类型</span><input id='i-auth-docdialog-add-admType' type='text' name='admType' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>允许类型</span><input id='i-auth-docdialog-add-appType' type='text' name='appType' />" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-auth-docdialog-add-isAudit' type='checkbox' name='isAudit' />" +
							"</div>" +
							"<div class='row'>" +
								
								"<span class='c-span'>所属院区</span><input style='width:406px;' id='i-auth-docdialog-add-hosp' type='text' name='hosp' />" +
							"</div>" +
							"<div class='row' style='text-align:center;'>" +
								//"<div class='col-xs-12' style='text-align:center;'><a id='c-auth-docdialog-add-save' class='btn btn-info c-btn' style='width:100px;'>保存</a></div>" +
								"<a id='c-auth-docdialog-add-save'>保存</a>" +
							"</div>" +
					"</div>";
				var $docdialog = $(docdialogStr);
				$("#i-auth-container").append($docdialog);
				/*
				$("#i-auth-docdialog-add input[type='checkbox']").iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});*/
				$("#c-auth-docdialog-add-save").linkbutton({
					iconCls:'icon-w-save'
				});
				$("#i-auth-docdialog-add-isAudit").checkbox();
				drawAuthDocDialog("i-auth-docdialog-add", "", "");
				$("#i-auth-docdialog-add input[name='itemId']").val("");
				$("#i-auth-docdialog-add-docname").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-docLevel").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-admType").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-kssLevel").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-appType").simplecombobox("setValue", "");
				$("#i-auth-docdialog-add-hosp").simplecombobox("setValue", PageLogicObj.m_CHosp);
				$("#i-auth-docdialog-add-isAudit").checkbox('uncheck'); 
			};
			
			$('#i-auth-docdialog-add').window({
				title: '新增医生权限', 
				iconCls:'icon-w-add',
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
					var hosp = $("#i-auth-docdialog-add-hosp").simplecombobox("getValue")||"";
					var isAudit=0
					if($("#i-auth-docdialog-add input[name='isAudit']").is(':checked')){
						isAudit=1
					};
					var tempFlag = (!!docLevel)&&(!!docName)&&(!!kssLevel)&&(!!appType)&&(!!admType)&&(!!hosp);
					if (!tempFlag) {
						layer.alert("请填写好必填字段！", {title:'提示',icon: 0}); 
						return false;
					};
					
					var paraStr = id + "^" + docName + "^" + docLevel + "^" + kssLevel + "^" + appType + "^" + admType + "^" + isAudit + "^^" + hosp;
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateAuthItemNew", paraStr);
					if (rtn == "-201") {
						layer.alert("已维护过该医生配置！", {title:'提示',icon: 0}); 
						return false;
					};
					if (rtn == "-202") {
						layer.alert("没有维护主表配置！", {title:'提示',icon: 0});
						return false;
					};
					layer.alert("添加成功！", {title:'提示',icon: 1}); 
					$('#i-auth-docdialog-add').window('close');
					reloadAuthGrid();
				} else {
					var docLevel = $("#i-9docAuth-docLevel").simplecombobox('getValue')||"",
						doc = $("#i-9docAuth-doc").simplecombobox('getValue')||"",
						hosp = $("#i-9docAuth-hosp").simplecombobox('getValue')||"";
					if ((!!!docLevel) || (!!!doc)|| (!!!hosp)) {
						var msg = [];
						if (docLevel == "") {
							msg.push("医护级别")
						}
						if (doc == "") {
							msg.push("医生姓名")
						}
						if (hosp == "") {
							msg.push("所属院区")
						}
						msg = msg.join("、") + "不能为空！"
						//layer.alert("医护级别、医生姓名、所属院区不能为空！", {title:'提示',icon: 0}); 
						layer.alert(msg, {title:'提示',icon: 0}); 
						return false;
					};
					var paraStr = build9DocAuthInfo(docAuthNum,"add9DocAuth");
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdate9DocAuth", paraStr, hosp);
					if (rtn == "-201") {
						layer.alert("已维护过该医生配置！", {title:'提示',icon: 0}); 
						return false;
					};
					if (rtn == "-202") {
						layer.alert("没有维护主表配置！", {title:'提示',icon: 0}); 
						return false;
					};
					layer.alert("添加成功！", {title:'提示',icon: 1}); 
					$('#i-auth-docdialog-add').window('close');
					reloadAuthGrid();
					
				}
			});
			
		} else {
			if (selected.ctDocId == "") {
				layer.alert("不是医生权限记录，不能修改！", {title:'提示',icon: 5}); 
				return false;
			};
			if (selected.tppPoisonDr == "") {
				var mcgId = selected.id,
					docId = selected.ctDocId,
					hospId = selected.hospId,
					prescAuth = 1;
					
				
				layer.confirm("您确认放开该医生抗菌处方权么？", {icon: 3, title:'提示'}, function(index){
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth,"","",hospId);
					if (rtn == "-2") {
						$.messager.alert('提示','更改失败，因为配置代码为空！','info');
						return false;
					};
					if (rtn == "-1") {
						$.messager.alert('提示','更改失败，因为配置代码已存在！','info');
						return false;
					};
					if (rtn == "-3") {
						layer.close(index);
						$.messager.alert('提示','更改失败，院区为空！','info');
						return false;
					};
					layer.alert("更改成功！", {title:'提示',icon: 1}); 
					reloadAuthGrid();
					layer.close(index);
				});
				/*
				$.messager.confirm('提示', '您确认放开该医生抗菌处方权么？', function(r){
					if (r){
						var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth);
						if (rtn == "-2") {
							$.messager.alert('提示','更改失败，因为配置代码为空...','info');
							return false;
						};
						if (rtn == "-1") {
							$.messager.alert('提示','更改失败，因为配置代码已存在...','info');
							return false;
						};
						$.messager.alert('恭喜','更改成功...','info');
						reloadAuthGrid();
					}
				});
				*/
				return true;
			};
			if (docAuthNum == 3) {
				var docAuthObj = ANT.DHC.get9DocAuth(selected.ctDocId, selected.hospId);
				DOC9AUTHOBJ = docAuthObj;
				var docdialogStr = "<div id='i-auth-docdialog' class='c-auth-docdialog-new container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<span>医护级别：" + selected.CTCPTDesc+ "</span>" +
								"<span class='c-span-sp'>医生姓名：" + selected.ctDocDesc + "</span>" +
								"<input id='i-9docAuth-docLevel' type='hidden' value='" + selected.rowId + "' />" +
								"<input id='i-9docAuth-doc' type='hidden' value='" + selected.ctDocId + "' />" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<span>所属院区：" + selected.hospDesc+ "</span>" +
								"<input id='i-9docAuth-hosp' type='hidden' value='" + selected.hospId + "' />" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>权限</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>非限制</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS1-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS1-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-IKSS1-itemId' type='hidden' value='" + docAuthObj.IAuth.kss1ItemId + "' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>限制级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS2-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS2-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-IKSS2-itemId' type='hidden' value='" + docAuthObj.IAuth.kss2ItemId + "' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>特殊级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS3-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS3-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-IKSS3-itemId' type='hidden' value='" + docAuthObj.IAuth.kss3ItemId + "' />" +
							"</div>" +
							"<div class='row' style='text-align:center;'>" +
								"<a id='c-auth-docdialog-save' class='btn btn-info c-btn' style='width:100px;'>保存</a>" +
							"</div>" +
					"</div>";
					
					var $docdialog = $(docdialogStr);
					$("#i-auth-container").append($docdialog);
					/*
					$("#i-auth-docdialog input[type='checkbox']").iCheck({
						labelHover : false,
						cursor : true,
						checkboxClass : 'icheckbox_square-blue',
						radioClass : 'iradio_square-blue',
						increaseArea : '20%'
					});*/
					$("#c-auth-docdialog-save").linkbutton({
						iconCls:'icon-w-save'
					});
					$("#i-9docAuth-IKSS3-verify").checkbox();
					$("#i-9docAuth-IKSS2-verify").checkbox();
					$("#i-9docAuth-IKSS1-verify").checkbox();
					draw9AuthDocDialog(docAuthObj);
					set9AuthDocVerify(docAuthObj);
			} else if (docAuthNum == 9) {
				var docAuthObj = ANT.DHC.get9DocAuth(selected.ctDocId, selected.hospId);
				DOC9AUTHOBJ = docAuthObj;
				var docdialogStr = "<div id='i-auth-docdialog' class='c-auth-docdialog-new container' style='height:500px;'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<span>医护级别：" + selected.CTCPTDesc+ "</span><span class='c-span-sp'></span>" +
								"<span>医生姓名：" + selected.ctDocDesc + "</span>" +
								"<input id='i-9docAuth-docLevel' type='hidden' value='" + selected.rowId + "' />" +
								"<input id='i-9docAuth-doc' type='hidden' value='" + selected.ctDocId + "' />" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-baseinfo'>" +
								"<span>所属院区：" + selected.hospDesc+ "</span>" +
								"<input id='i-9docAuth-hosp' type='hidden' value='" + selected.hospId + "' />" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>门诊</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>非限制</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-OKSS1-control' type='text' />" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-OKSS1-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-OKSS1-itemId' type='hidden' value='" + docAuthObj.OAuth.kss1ItemId + "' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>限制级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-OKSS2-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-OKSS2-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-OKSS2-itemId' type='hidden' value='" + docAuthObj.OAuth.kss2ItemId + "' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>特殊级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-OKSS3-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-OKSS3-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-OKSS3-itemId' type='hidden' value='" + docAuthObj.OAuth.kss3ItemId + "' />" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>急诊</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>非限制</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-EKSS1-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-EKSS1-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-EKSS1-itemId' type='hidden' value='" + docAuthObj.EAuth.kss1ItemId + "' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>限制级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-EKSS2-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-EKSS2-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-EKSS2-itemId' type='hidden' value='" + docAuthObj.EAuth.kss2ItemId + "' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>特殊级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-EKSS3-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-EKSS3-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-EKSS3-itemId' type='hidden' value='" + docAuthObj.EAuth.kss3ItemId + "' />" +
							"</div>" +
							"<div class='row c-auth-docdialog-new-h4row'>" +
								"<div class='col-xs-12'><h4>住院</h4></div>" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>非限制</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS1-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS1-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-IKSS1-itemId' type='hidden' value='" + docAuthObj.IAuth.kss1ItemId + "' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>限制级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS2-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS2-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-IKSS2-itemId' type='hidden' value='" + docAuthObj.IAuth.kss2ItemId + "' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>特殊级</span>" +
								"<span class='c-span-sp'></span><span class='c-span'>允许类型</span><input id='i-9docAuth-IKSS3-control' type='text'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-9docAuth-IKSS3-verify' type='checkbox'/>" +
								"<input id='i-9docAuth-IKSS3-itemId' type='hidden' value='" + docAuthObj.IAuth.kss3ItemId + "' />" +
							"</div>" +
							"<div class='row' style='text-align:center;'>" +
								"<a id='c-auth-docdialog-save'>保存</a>" +
							"</div>" +
					"</div>";
					var $docdialog = $(docdialogStr);
					$("#i-auth-container").append($docdialog);
					/*
					$("#i-auth-docdialog input[type='checkbox']").iCheck({
						labelHover : false,
						cursor : true,
						checkboxClass : 'icheckbox_square-blue',
						radioClass : 'iradio_square-blue',
						increaseArea : '20%'
					});*/
					$("#c-auth-docdialog-save").linkbutton({
						iconCls:'icon-w-save'
					});
					
					$("#i-9docAuth-OKSS1-verify").checkbox();
					$("#i-9docAuth-OKSS2-verify").checkbox();
					$("#i-9docAuth-OKSS3-verify").checkbox();
					
					$("#i-9docAuth-EKSS1-verify").checkbox();
					$("#i-9docAuth-EKSS2-verify").checkbox();
					$("#i-9docAuth-EKSS3-verify").checkbox();
					
					$("#i-9docAuth-IKSS3-verify").checkbox();
					$("#i-9docAuth-IKSS2-verify").checkbox();
					$("#i-9docAuth-IKSS1-verify").checkbox();
					//$("#i-auth-docdialog-isAudit").checkbox();
					draw9AuthDocDialog(docAuthObj);
					set9AuthDocVerify(docAuthObj);
			} else {
				var docdialogStr = "<div id='i-auth-docdialog' class='c-auth-docdialog container'>" +
							"<input type='hidden' name='itemId' />" +
							"<div class='row'>"  +
								"<span class='c-span'>医护级别</span><input id='i-auth-docdialog-docLevel' type='text' name='docLevel'/>" +
								"<span class='c-span-sp'></span><span class='c-span'>医生姓名</span><input id='i-auth-docdialog-docname' type='text' name='docname' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>抗菌级别</span><input id='i-auth-docdialog-kssLevel' type='text' name='kssLevel' />" +
								"<span class='c-span-sp'></span><span class='c-span'>就诊类型</span><input id='i-auth-docdialog-admType' type='text' name='admType' />" +
							"</div>" +
							"<div class='row'>" +
								"<span class='c-span'>允许类型</span><input id='i-auth-docdialog-appType' type='text' name='appType' />" +
								"<span class='c-span-sp'></span><span class='c-span'>审核权限</span><input id='i-auth-docdialog-isAudit' type='checkbox' name='isAudit' />" +
							"</div>" +
							"<div class='row'>" +
							"<span class='c-span'>所属院区</span><input style='width:406px;' id='i-auth-docdialog-hosp' type='text' name='hosp' />" +
								
							"</div>" +
							"<div class='row' style='text-align:center;'>" +
								"<a id='c-auth-docdialog-save'>保存</a>" +
							"</div>" +
					"</div>";
					var $docdialog = $(docdialogStr);
					$("#i-auth-container").append($docdialog);
					/*
					$("#i-auth-docdialog input[type='checkbox']").iCheck({
						labelHover : false,
						cursor : true,
						checkboxClass : 'icheckbox_square-blue',
						radioClass : 'iradio_square-blue',
						increaseArea : '20%'
					});*/
					$("#c-auth-docdialog-save").linkbutton({
						iconCls:'icon-w-save'
					});
					$("#i-auth-docdialog-isAudit").checkbox();
					drawAuthDocDialog("i-auth-docdialog", selected.rowId, selected.tppControlType,selected.ctDocId);
					$("#i-auth-docdialog input[name='itemId']").val(selected.id);
					//$("#i-auth-docdialog-docname").simplecombobox("setValue", selected.ctDocId);
					//$("#i-auth-docdialog-docLevel").simplecombobox("setValue", selected.rowId);
					$("#i-auth-docdialog-admType").combobox("setValue", selected.tppEpisodeType);
					$("#i-auth-docdialog-kssLevel").simplecombobox("setValue", selected.tppPoisonDr);
					$("#i-auth-docdialog-appType").combobox("setValue", selected.tppControlType);
					$("#i-auth-docdialog-hosp").combobox("setValue", selected.hospId);
					if (selected.tppChkVerify == 1) {
						$("#i-auth-docdialog-isAudit").checkbox('check'); 
					} else {
						$("#i-auth-docdialog-isAudit").checkbox('uncheck'); 
					};
			};
			$('#i-auth-docdialog').window({
				iconCls:'icon-w-edit',
				title: '修改医生权限允许类型与审核权限',
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
					var id = $("#i-auth-docdialog input[name='itemId']").val();	//字表ID
					var mainId="";
					var docName = $("#i-auth-docdialog-docname").simplecombobox("getValue");
					var docLevel = $("#i-auth-docdialog-docLevel").simplecombobox("getValue");
					var kssLevel = $("#i-auth-docdialog-kssLevel").simplecombobox("getValue");
					var appType = $("#i-auth-docdialog-appType").simplecombobox("getValue")||"";
					var admType = $("#i-auth-docdialog-admType").simplecombobox("getValue");
					var hosp = $("#i-auth-docdialog-hosp").simplecombobox("getValue")||"";
					var isAudit=0
					if($("#i-auth-docdialog input[name='isAudit']").is(':checked')){
						isAudit=1
					};
					if (!!!appType) {
						layer.alert("允许类型不能为空，谢谢！", {title:'提示',icon: 0}); 
						return false;
					};
					var mStry = id.match(/\|+/g);
					if (mStry.length == "1") {	//主表记录，插入子表
						mainId = id;
						id = "";
					}
					var paraStr = id + "^" + docName + "^" + docLevel + "^" + kssLevel + "^" + appType + "^" + admType + "^" + isAudit + "^" + mainId + "^" + hosp;
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateAuthItemNew", paraStr);
					
					if (rtn == "-201") {
						layer.alert("已维护过该医生配置！", {title:'提示',icon: 0}); 
						return false;
					} 
					if (rtn == "-202") {
						layer.alert("没有维护主表配置！", {title:'提示',icon: 0}); 
						return false;
					};
					layer.alert("修改成功！", {title:'提示',icon: 1}); 
					$('#i-auth-docdialog').window('close');
					reloadAuthGrid();
				} else {
					var paraStr = build9DocAuthInfo(docAuthNum,undefined,DOC9AUTHOBJ);
					if (paraStr == "") {
						layer.alert("没有填写不能保存！", {title:'提示',icon: 0}); 
						return false;
					}
					var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdate9DocAuth", paraStr, selected.hospId);
					if (rtn == "-201") {
						layer.alert("已维护过该医生配置！", {title:'提示',icon: 0}); 
						return false;
					};
					if (rtn == "-202") {
						layer.alert("没有维护主表配置！", {title:'提示',icon: 0}); 
						return false;
					};
					if (rtn == "-203") {
						layer.alert("允许类型不能为空！", {title:'提示',icon: 0}); 
						return false;
					};
					layer.alert("修改成功！", {title:'提示',icon: 1}); 
					$('#i-auth-docdialog').window('close');
					reloadAuthGrid();
				}
			});
			
		};
	}
	
	$("#i-auth-docdelete").on('click', function(){
		var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected){ 
			layer.alert("请选择一条医生记录！", {title:'提示',icon: 0}); 
			return false;
		};
		var itemId = selected.id, docId = selected.ctDocId;
		if (docId == "") {
			layer.alert("不是医生权限记录，不能删除！", {title:'提示',icon: 5}); 
			return false;
		};
		var mStry = itemId.match(/\|+/g);
		if (!mStry) {	//处理null
			layer.alert("不能删除允许类型为无处方权的配置！", {title:'提示',icon: 0}); 
			return false;
		}
		if (mStry.length != "2") {
			layer.alert("没有维护医生权限，不能删除！", {title:'提示',icon: 0}); 
			return false;
		}
		var message = "您确认删除该医生权限配置么？";
		
		layer.confirm(message, {icon: 3, title:'提示'}, function(index){
			var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBDeleteCPTPCp", itemId);
				if (rtn != "0") {
					$.messager.alert('提示','删除失败！','info');
					return false;
				};
			layer.alert("删除成功！", {title:'提示',icon: 1}); 
			reloadAuthGrid();
			layer.close(index);
		});
		/*
		$.messager.confirm('提示', message, function(r){
			if (r){
				var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBDeleteCPTPCp", itemId);
				if (rtn != "0") {
					$.messager.alert('提示','删除失败...','info');
					return false;
				};
				$.messager.alert('恭喜','删除成功...','info');
				reloadAuthGrid();
			}
		});
		*/
		return true;
				
	});
	
	//更改处方权，增加日期功能
	$("#i-auth-docforbidden").on('click', function(){
		var selected = $('#i-auth-grid').simpledatagrid('getSelected');
		if (!selected){ 
			layer.alert("请选择一条医生记录！", {title:'提示',icon: 0}); 
			return false;
		};
		var mcgId = selected.id, prescAuth = selected.docAut, docId = selected.ctDocId;
		if (docId == "") {
			layer.alert("不是医生权限记录，不能修改！", {title:'提示',icon: 5}); 
			return false;
		}
		if (mcgId.indexOf("||") > 0 ) mcgId = "";
		if (prescAuth != "0") {	//1和"" 表示有权限,此时要禁止
			prescAuth = 0; 
		} else {
			//prescAuth = 1; 		//0表示无权限，此时要放开
		}
		var message = "您确认禁止该医生所有抗菌处方权么？";
		if (prescAuth == "1") {
			message = "您确认放开该医生抗菌处方权么？";
		};
		
		//添加开始日期和结束日期
		var docdialogStr = "<div id='i-diag' class='c-auth-docdialog container'>" +
				"<div class='row'>"  +
					"<span class='c-span'>开始日期</span><input id='i-sdate' class='hisui-datebox textbox' type='text' style='width:250px;' />" +
				"</div>" +
				"<div class='row'>" +
					"<span class='c-span'>结束日期</span><input id='i-edate' class='hisui-datebox textbox' type='text' style='width:250px;'  />" +
				"</div>" +
				"<div class='row'>" +
					"<span class='c-span'>所属院区</span><input id='i-hosp2' class='textbox' type='text' style='width:250px;'  />" +
				"</div>" +
				"<div class='row' style='text-align:center;'>" +
					"<a id='saveForbidden'>保存</a>" +
				"</div>" +
		"</div>";
		var cSDate = selected.DateFrom,cEDate = selected.DateTo;
		var $docdialog = $(docdialogStr);
		$("#i-auth-container").append($docdialog);
		$("#saveForbidden").linkbutton({
			iconCls:'icon-w-save'
		});
		$("#i-sdate").datebox({
			value:cSDate
		});
		$("#i-edate").datebox({
			value:cEDate
		});
		
		$('#i-diag').window({
			iconCls:'icon-w-edit',
			title: '更改处方权',
			modal: true,
			minimizable:false,
			maximizable:false,
			collapsible:false,
			onClose: function () {
				$("#i-diag").window('destroy');
				$docdialog.remove();
			}
		});
		
		$("#i-hosp2").simplecombobox({
			required:true,
			disabled:true,
			value:selected.hospId,
			onBeforeLoad: function(param){
				param.ClassName="DHCAnt.KSS.Config.Authority";
				param.QueryName="QryHosp";
				param.ModuleName="combobox";
				param.ArgCnt=0;
			}
		});
		
		$("#saveForbidden").on("click", function() {
			var sdate = $("#i-sdate").datebox("getValue")||"";
			var edate = $("#i-edate").datebox("getValue")||"";
			var hospId = $("#i-hosp2").simplecombobox("getValue")||"";
			if ((sdate == "")||(edate == "")) {
				layer.alert("开始日期和结束日期不能为空！", {title:'提示',icon: 5}); 
				return false;
			}
			if (sdate > edate) {
				layer.alert("开始日期不能大于结束日期！", {title:'提示',icon: 5}); 
				return false;
			}
			if (hospId == "") {
				layer.alert("请选择院区！", {title:'提示',icon: 5}); 
				return false;
			}
			var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth,sdate,edate,hospId);
			if (rtn == "-2") {
				layer.alert("更改失败，配置代码为空！", {title:'提示',icon: 0}); 
				return false;
			};
			if (rtn == "-1") {
				layer.alert("更改失败，配置代码已存在！", {title:'提示',icon: 0}); 
				return false;
			};
			$('#i-diag').window("close");
			layer.alert("更改成功！", {title:'提示',icon: 1}); 
			reloadAuthGrid();
		});
		
		/*
		layer.confirm(message, {icon: 3, title:'提示'}, function(index){
			var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth);
			if (rtn == "-2") {
				layer.alert("更改失败，因为配置代码为空...", {title:'提示',icon: 0}); 
				return false;
			};
			if (rtn == "-1") {
				layer.alert("更改失败，因为配置代码已存在...", {title:'提示',icon: 0}); 
				return false;
			};
			layer.alert("更改成功...", {title:'提示',icon: 1}); 
			reloadAuthGrid();
			layer.close(index);
		});
		
		*/
		
		/*
		$.messager.confirm('提示', message, function(r){
			if (r){
				var rtn = $.InvokeMethod("DHCAnt.KSS.Config.Authority","DBUpdateNOAUTHDOC", mcgId, docId, prescAuth);
				if (rtn == "-2") {
					$.messager.alert('提示','更改失败，因为配置代码为空...','info');
					return false;
				};
				if (rtn == "-1") {
					$.messager.alert('提示','更改失败，因为配置代码已存在...','info');
					return false;
				};
				//$.messager.alert('提示','更改成功...','info');
				layer.alert("更改成功...", {
					title:'提示',
					icon: 1
				}); 
				reloadAuthGrid();
			}
		});
		*/	
		return true;
	});
	
	$("#i-auth-import").on('click', function(){
		var src="dhcant.kss.config.auth.import.csp?a=1";
        if ('undefined'!==typeof websys_getMWToken){
            src += "&MWToken="+websys_getMWToken();
        }
		var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
		createModalDialog("importDiag","导入", 950, 545,"icon-w-import","",$code,"");
	});
	
	$("#i-auth-import2").on('click', function(){
		if ( !ANT.IESupport(browserType) ){
			return false;
		};
		var $fileOBJ = $("#i-file");
		$fileOBJ.val("");
		if ($fileOBJ.length > 0) {
			$fileOBJ.get(0).click();
		} else {
			layer.alert("请选择文件！", {title:'提示',icon: 0}); 
			return false;
		}
		var filePath = $fileOBJ.val();
		if ((filePath =="")||(!filePath)){
			return false;
		}
		MaskUtil.mask("正在导入，请稍等。。。");
        window.setTimeout(function () {
            ANT.parseExcel({
				filePath: filePath,
				className: "DHCAnt.KSS.Config.Authority",
				method: "ImportExcel",
				MaskUtil: MaskUtil
			});
			reloadAuthGrid();
        },100);
		
		return false;
	});
	
	$("#i-auth-clear").on("click", function () {
		clearScreen();
	});
	$("#i-auth-condition-docnum").keydown(function (event) {
		if (event.which == 13 || event.which == 9) {
			reloadAuthGrid();
		}
	});
	
	$("#i-auth-export").on('click', function () {
		if (PageLogicObj.m_CHosp == "") {
			layer.alert("请先选择院区再进行导出！", {title:'提示',icon: 0}); 
			return false;
		}
		var arg1="",arg2="",arg3="",
			arg4="",arg5="",arg6="",
			arg7="",arg8="",arg9="",
			arg10="";
		//arg10 = $('#i-auth-condition-hosp').simplecombobox('getValue')||"";	//院区
		arg10 = PageLogicObj.m_CHosp;	//院区
		if(!$("#i-auth-condition-switch").is(':checked')){
			arg2=$("#i-auth-condition-loc").simplecombobox('getValue')||"";	//科室id
			arg3=$("#i-auth-condition-docLevel").simplecombobox('getValue')||"";	//医生级别
			arg4=$("#i-auth-condition-docname").simplecombobox('getValue')||"";	//医生id
			arg5=$("#i-auth-condition-docnum").val();	//医生工号
			arg6=$("#i-auth-condition-admType").simplecombobox('getValue')||"";	//就诊类型
			arg7=$("#i-auth-condition-kssLevel").simplecombobox('getValue')||"";	//抗菌药物级别
			
			if($("#i-auth-condition-prescAuth").is(':checked')){
				arg8=1	//医师处方权
			};
			if($("#i-auth-condition-verifyAuth").is(':checked')){
				arg9=1;	//审核权限
			};
		} else {
			arg1=1;
			arg3=$("#i-auth-condition-docLevel").simplecombobox('getValue')||"";	//医生级别
			arg6=$("#i-auth-condition-admType").simplecombobox('getValue')||"";	//就诊类型
			arg7=$("#i-auth-condition-kssLevel").simplecombobox('getValue')||"";	//抗菌药物级别
			if($("#i-auth-condition-verifyAuth").is(':checked')){
				arg9=1;	//审核权限
			};
		};
		
		if ((arg2 == "") && (arg3 == "") && (arg4 == "") && (arg5 == "") && (arg6 == "") && (arg7 == "")&& (arg8 == "") && (arg9 == "")) {
			arg1 = 1;
		}
		if (arg9 == 1) {
			if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
				layer.alert("请选择权限类型、医护级别、科室、医生姓名或医生工号中任意一个再进行查询！", {title:'提示',icon: 0}); 
				return false;
			}
		}
		if (arg6 != "") {
			if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
				layer.alert("请选择权限类型、医护级别、科室、医生姓名或医生工号中任意一个再进行查询！", {title:'提示',icon: 0}); 
				return false;
			}
		}
		if (arg7 != "") {
			if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
				layer.alert("请选择权限类型、医护级别、科室、医生姓名或医生工号中任意一个再进行查询！", {title:'提示',icon: 0}); 
				return false;
			}
		}
		
		//方式一
		/*$.messager.confirm("提示", "确定导出么?", function (r) {
			if (r) {
				var rtn = $cm({
					localDir:"Self", 
					ResultSetTypeDo:"Export",
					//dataType:'text',
					ResultSetType:"ExcelPlugin", //Excel
					ExcelName:"KJAuthorityData",
					ClassName:"DHCAnt.KSS.Config.Authority",
					QueryName:"Export",
					isCkecked:arg1,
					locId:arg2,
					docLevel:arg3,
					docId:arg4,
					docNum:arg5,
					admType:arg6,
					poisonId:arg7,
					isKSSAuthority:arg8,
					isVerifyAuthority:arg9,
					InHosp:arg10
				},true);
				
			} else {
				//
			}
		});*/
		
		//方式二
		//location.href = tkMakeServerCall("websys.Query","ToExcel","DHCEventLog","web.DHCEventLogDetails","FindParAndDet",$('#StDate').datebox("getValue"),$('#EndDate').datebox("getValue"),$('#User').combogrid("getValue"),$('#AuditFlag').combobox("getValue"),$('#Model').combogrid("getValue"),$('#Type').combobox("getValue"));
		
		
		location.href = tkMakeServerCall("websys.Query","ToExcel","抗菌药物权限","DHCAnt.KSS.Config.Authority","Export",arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10);
		
		//方式三
		/*
		var rtn = $cm({
					dataType:'text',
					ResultSetType:'Excel',
					ExcelName:'抗菌药物权限',
					ClassName:'DHCAnt.KSS.Config.Authority',
					QueryName:'Export',
					isCkecked:arg1,
					locId:arg2,
					docLevel:arg3,
					docId:arg4,
					docNum:arg5,
					admType:arg6,
					poisonId:arg7,
					isKSSAuthority:arg8,
					isVerifyAuthority:arg9,
					InHosp:arg10
					
				}, false);
				location.href = rtn;
				
		
		*/
		
	})
	
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

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

function reloadAuthGrid(notip) {
	if (PageLogicObj.m_CHosp == "") {
		layer.alert("请先选择院区再进行查询！", {title:'提示',icon: 0}); 
		return false;
	}
	notip = notip||"";
	var arg1="",arg2="",arg3="",
		arg4="",arg5="",arg6="",
		arg7="",arg8="",arg9="",
		arg10="",arg11="";
	//arg10 = $('#i-auth-condition-hosp').simplecombobox('getValue')||"";	//院区
	arg10 = PageLogicObj.m_CHosp;	//院区
	if(!$("#i-auth-condition-switch").is(':checked')){
		arg2=$("#i-auth-condition-loc").simplecombobox('getValue')||"";	//科室id
		arg3=$("#i-auth-condition-docLevel").simplecombobox('getValue')||"";	//医生级别
		arg4=$("#i-auth-condition-docname").simplecombobox('getValue')||"";	//医生id
		arg5=$("#i-auth-condition-docnum").val();	//医生工号
		arg6=$("#i-auth-condition-admType").simplecombobox('getValue')||"";	//就诊类型
		arg7=$("#i-auth-condition-kssLevel").simplecombobox('getValue')||"";	//抗菌药物级别
		
		if($("#i-auth-condition-prescAuth").is(':checked')){
			arg8=1	//医师处方权
		};
		if($("#i-auth-condition-verifyAuth").is(':checked')){
			arg9=1;	//审核权限
		};
	} else {
		arg1=1;
		arg3=$("#i-auth-condition-docLevel").simplecombobox('getValue')||"";	//医生级别
		arg6=$("#i-auth-condition-admType").simplecombobox('getValue')||"";	//就诊类型
		arg7=$("#i-auth-condition-kssLevel").simplecombobox('getValue')||"";	//抗菌药物级别
		if($("#i-auth-condition-verifyAuth").is(':checked')){
			arg9=1;	//审核权限
		};
	};
	if (notip == 1) {
		arg1 = 1;
	}
	if ((arg2 == "") && (arg3 == "") && (arg4 == "") && (arg5 == "") && (arg6 == "") && (arg7 == "")&& (arg8 == "") && (arg9 == "")) {
		arg1 = 1;
	}
	if (arg9 == 1) {
		if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
			layer.alert("请选择权限类型、医护级别、科室、医生姓名或医生工号中任意一个再进行查询！", {title:'提示',icon: 0}); 
			return false;
		}
	}
	if (arg6 != "") {
		if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
			layer.alert("请选择权限类型、医护级别、科室、医生姓名或医生工号中任意一个再进行查询！", {title:'提示',icon: 0}); 
			return false;
		}
	}
	if (arg7 != "") {
		if ((arg2=="")&&(arg3=="")&&(arg4=="")&&(arg5=="")&&(arg1=="")) {
			layer.alert("请选择权限类型、医护级别、科室、医生姓名或医生工号中任意一个再进行查询！", {title:'提示',icon: 0}); 
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
		Arg10:arg10,
		Arg11:arg11,
		ArgCnt:11
	});
}
function clearScreen () {
	// $("#i-auth-condition-switch").iCheck('uncheck'); 
	// $("#i-auth-condition-verifyAuth").iCheck('uncheck'); 
	// $("#i-auth-condition-prescAuth").iCheck('uncheck'); 
	$("#i-auth-condition-switch").checkbox('uncheck'); 
	$("#i-auth-condition-verifyAuth").checkbox('uncheck'); 
	$("#i-auth-condition-prescAuth").checkbox('uncheck'); 
	$("#i-auth-condition-docLevel").simplecombobox("setValue","");
	$("#i-auth-condition-loc").simplecombobox("setValue","");
	$("#i-auth-condition-docname").simplecombobox("setValue","");
	$("#i-auth-condition-docnum").val("");
	$("#i-auth-condition-admType").simplecombobox("setValue","");
	//$("#i-auth-condition-hosp").simplecombobox("setValue","");
	$("#i-auth-condition-kssLevel").simplecombobox("setValue","");
	
	$('#i-auth-condition-docname').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryDoctor";
			param.ModuleName="combobox";
			param.Arg1="";
			param.Arg2="";
			param.Arg3 = "";
			param.Arg4 = GetHospValue();
			param.ArgCnt=4;
		}
	});
	//处理HISUIBUG QP 2018-04-28
	//ANT.DHC.setHUICombo(browserType);
	reloadAuthGrid();
}

/**
 * QP
 * 2019-01-16
 * 刷新医生下拉框数据【增加了，医护级别change事件处理】
 * @param {*} record 
 */
function flushDoc (levelId, locId) {
	levelId = levelId||"", locId = locId||"";
	//console.log("Para: " + levelId + "^" + locId);
	var Arg2 = levelId, Arg1 = locId;
	//医护级别下拉框
	if (levelId != "") {
		Arg1 = $('#i-auth-condition-loc').simplecombobox("getValue")||"";
		Arg2 = levelId;
	}
	//科室下拉框
	if ( (!!locId) &&(locId != "") ) {
		Arg1 = locId;
		Arg2 = $('#i-auth-condition-docLevel').simplecombobox("getValue")||"";
	}
	if ((levelId == "") && (locId == "") ) {
		Arg1 = $('#i-auth-condition-loc').simplecombobox("getValue")||"";
		Arg2 = $('#i-auth-condition-docLevel').simplecombobox("getValue")||"";
	}
	//console.log("Arg: " + Arg1 + "^" + Arg2);
	if(!$("#i-auth-condition-switch").is(':checked')){
		$('#i-auth-condition-docname').simplecombobox({
			onBeforeLoad: function(param){
				param.ClassName = "DHCAnt.KSS.Config.Authority";
				param.QueryName = "QryDoctor";
				param.ModuleName = "combobox";
				param.Arg1 = Arg1;
				param.Arg2 = Arg2;
				param.Arg3 = "";
				param.Arg4 = GetHospValue();
				param.ArgCnt = 4;
			}
		});
		//处理HISUIBUG QP 2018-04-28
		//ANT.DHC.setHUICombo(browserType);
		$('#i-auth-condition-docname').simplecombobox("enable");
	}
}
	
function InitComboxLinkHosp () {
	//抗菌级别Combox
	$('#i-auth-condition-kssLevel').simplecombobox({
		blurValidValue:true,
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryKSSLevl";
			param.ModuleName="combobox";
			param.Arg1=PageLogicObj.m_CHosp;
			param.ArgCnt=1;
		}
	});
	
	//医生科室Combox
	$('#i-auth-condition-loc').simplecombobox({
		blurValidValue:true,
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryGetdep";
			param.ModuleName="combobox";
			param.Arg1="";
			param.Arg2=GetHospValue();
			param.ArgCnt=2;
		},
		editable:true,
		onChange: function (newValue, oldValue) {
			//console.log(newValue + ": " + oldValue);
			if (newValue == undefined) {
				
				flushDoc("", "");
			}
		},
		onSelect:function(record) {
			flushDoc("", record.id)
		},
		onUnselect: function () {
			$(this).simplecombobox('setValue', '');
			flushDoc("", "");
		}
	});
	
}

function InitHospList() {
	PageLogicObj.m_HospBox = GenHospComp("Ant_Config_Auth");
	PageLogicObj.m_HospBox.jdata.options.onSelect = function(rowIndex,data){
		PageLogicObj.m_CHosp = data.HOSPRowId;
		docAuthNum = $.trim(ANT.DHC.getDocAuthNum(data.HOSPRowId));
		clearScreen();
		reloadAuthGrid();
		InitComboxLinkHosp()
	}
	PageLogicObj.m_HospBox.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.m_CHosp = session['LOGON.HOSPID'];
		docAuthNum = $.trim(ANT.DHC.getDocAuthNum(session['LOGON.HOSPID'])),
		clearScreen();
		reloadAuthGrid();
		InitComboxLinkHosp()
	}
}

function GetHospValue() {
	if (PageLogicObj.m_CHosp == "") {
		return session['LOGON.HOSPID'];
	}
	
	return PageLogicObj.m_CHosp
}
function InitCache () {
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}

