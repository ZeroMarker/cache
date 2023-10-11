//页面Gui
var objScreen = new Object();
function InitHandHyRegWin() {
    var obj = objScreen;
	if (typeof ParamAdmin === 'undefined'){
		obj.ParamAdmin="";
	}else{
		obj.ParamAdmin=ParamAdmin;
	}
	
	obj.RegID = RegID;
	obj.ObsLocID  = ObsLocID;
	obj.ObsDate  = ObsDate;
	obj.ObsPage = ObsPage;
	obj.ObsMethod  = ObsMethod;
	obj.ObsUser = ObsUser;
	
    // 指征：671||病人前^672||操作前^673||体液后^674||病人后^675||环境后
    obj.ItemStr1 = $m({          //当前页(默认最后一页)
        ClassName: "DHCHAI.IRS.HandHyRegSrv",
        MethodName: "GetHandHyItems",
        aTypeCode: "HandHyOpportunity"
    }, false);
    // 措施：676||手消^677||肥皂和水^678||无
    obj.ItemStr2 = $m({          //当前页(默认最后一页)
        ClassName: "DHCHAI.IRS.HandHyRegSrv",
        MethodName: "GetHandHyItems",
        aTypeCode: "HandHyFacilities"
    }, false);
	//不正确原因
	obj.ItemStr3 = $m({          
        ClassName: "DHCHAI.IRS.HandHyRegSrv",
        MethodName: "GetHandHyItems",
        aTypeCode: "HandHyErrReason"
    }, false);
	
    //创建指征模块
    function CreatForm1(cmp, val) {
        var htmlstr = ''
        if (!cmp) return htmlstr;

        htmlstr += '<div>'
        htmlstr += '    <ul id="' + cmp + '">'

        var arrVal = val.split('!!');
        var val = arrVal[0];
        var arrValue = val.split(',');

        var arrItemStr = obj.ItemStr1.split('^');
        var itemId = cmp + '-I1'
        for (var ind = 0; ind < arrItemStr.length; ind++) {
            var arrItem = arrItemStr[ind].split('||');
            var checked = (arrValue.indexOf(arrItem[0]) < 0 ? "" : "checked");
            htmlstr += '<li >'
            htmlstr += '	<span><input class=\'hisui-checkbox\' type="checkbox" name="' + itemId + '" id="' + itemId + '-' + arrItem[0] + '" ' + checked + '></span>' + arrItem[1]
            htmlstr += '</li>'
        }

        htmlstr += '    </ul>'
        htmlstr += '</div>'
        return htmlstr;
    }
    function CreatForm2(cmp, val) {
        var htmlstr = ''
        if (!cmp) return htmlstr;
        htmlstr += '<div>'
        htmlstr += '    <ul id="' + cmp + '">'

        var arrVal = val.split('!!');
        var val = arrVal[0];
        var arrValue = val.split('^');
        var arrItemStr = obj.ItemStr2.split('^');
        var itemId = cmp + '-I2'
        for (var ind = 0; ind < arrItemStr.length; ind++) {
	        if(ind==0){
		    var arrItem = arrItemStr[ind].split('||');
            var checked = (arrValue.indexOf(arrItem[0]) < 0 ? "false" : "true");
            htmlstr += '<li style="margin-top:7px">'
            htmlstr += '	<span><input class=\'hisui-radio\' type="radio" name="' + itemId + '" id="' + itemId + '-' + arrItem[0] + '"data-options="checked: ' + checked + '"></span>' + arrItem[1]
            htmlstr += '</li>'    //为了上面10px间距
		    }else{
            var arrItem = arrItemStr[ind].split('||');
            var checked = (arrValue.indexOf(arrItem[0]) < 0 ? "false" : "true");
            htmlstr += '<li>'
            htmlstr += '	<span><input class=\'hisui-radio\' type="radio" name="' + itemId + '" id="' + itemId + '-' + arrItem[0] + '"data-options="checked: ' + checked + '"></span>' + arrItem[1]
            htmlstr += '</li>'
		    }
        }

        var val = arrVal[1];
        var itemId = cmp + '-I3'
        var checked = (val !== '1' ? "" : "checked");
        htmlstr += '<li>'
        htmlstr += '	<span><input class=\'hisui-checkbox\' type="checkbox" id="' + itemId + '" ' + checked + '></span>戴手套'
        htmlstr += '</li>'

        var val = arrVal[2];
        var itemId = cmp + '-I4'
        var checked = (val !== '1' ? "" : "checked");
        htmlstr += '<li class="input-group" style="margin-bottom:7px">'
        htmlstr += '	<span><input class=\'hisui-checkbox\' type="checkbox" id="' + itemId + '" ' + checked + '></span>正确'
        htmlstr += '</li>'

        htmlstr += '    </ul>'
        htmlstr += '</div>'
        return htmlstr;
    }
	
	 function CreatForm3(cmp, val) {
        var htmlstr = ''
        if (!cmp) return htmlstr;
      
        htmlstr += '<div>'
        htmlstr += '    <ul id="' + cmp + '">'

		var arrVal = val.split('!!');
        var val = arrVal[0];
		//不正确原因其他
		var other=arrVal[1]
        var arrValue = val.split(',');
        var arrItemStr = obj.ItemStr3.split('^');
        var itemId = cmp + '-I5'
		var errorCheck=false
		for (var ind = 0; ind < arrItemStr.length; ind++) {
            var arrItem = arrItemStr[ind].split('||');
            var checked = (arrValue.indexOf(arrItem[0]) < 0 ? "false" : "true");
			if(arrItem[1].indexOf($g("其他"))>-1&&checked=="true"){
				errorCheck=true
			}
            htmlstr += '<li>'
            htmlstr += '	<input class="hisui-checkbox" type="checkbox" name="' + itemId + '" id="' + itemId + '-' + arrItem[0] + '" label="'+ arrItem[1] + '"data-options="checked: ' + checked + '">'
            htmlstr += '</li>'
        }
		if(errorCheck){
			htmlstr += '<li>'
			htmlstr += '	<input class="textbox" id="' + cmp + '-Other" style="width: 150px;" value="' + other + '" placeholder="'+$g("其他原因说明...")+'">'
			htmlstr += '</li>'
		}
		else{
			htmlstr += '<li>'
			htmlstr += '	<input class="textbox" id="' + cmp + '-Other" style="width: 150px; display: none;" placeholder="'+$g("其他原因说明...")+'">'
			htmlstr += '</li>'
		}
        htmlstr += '    </ul>'
        htmlstr += '</div>'
        return htmlstr;
    }
	//
	//加载人员公共方法
	function Common_LookupToDoc() {
		var ItemCode = arguments[0];
		$("#"+ItemCode).lookup({
			panelWidth:220,
			url:$URL,
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			valueField: 'ID',
			textField: 'UserDesc',
			queryParams:{
				ClassName: 'DHCHAI.BTS.SysUserSrv',
				QueryName: 'QrySysUserList',
				aIsActive: 1
			},
			columns:[[  
				{field:'UserCode',title:$g('工号'),width:90},
				{field:'UserDesc',title:$g('姓名'),width:100}			
			]],
			onBeforeLoad:function(param){
				var desc=param['q']; 
				param = $.extend(param,{aUserName:desc}); //将参数q转换为类中的参数
			},
			pagination:true,
		    showPageList:false, showRefresh:false,displayMsg:'',
			loadMsg:'正在查询',
			isCombo:true,             //是否输入字符即触发事件，进行搜索
			minQueryLen:1             //isCombo为true时，可以搜索要求的字符最小长度
		});
	}
	if (obj.RegID) {
		$('#TabReg').css('display','none');
	}
	//控制表格样式
	if (ServerObj.RegVer!='2') {
		//版本1
		var ObsType1="",ObsType2="",ObsType3="",ObsType4="",ObsTypeID1="",ObsTypeID2="",ObsTypeID3="",ObsTypeID4="";;  //专业/职业
		var ObsTypeList= $m({          
			ClassName: "DHCHAI.BTS.DictionarySrv",
			MethodName: "GetIDDicList",
			aTypeCode: "HandHyObsType"
		}, false);
		if (ObsTypeList) {
			var arrObsType =ObsTypeList.split(CHR_1);
			ObsType1=arrObsType[0].split(CHR_2)[1];
			ObsType2=arrObsType[1].split(CHR_2)[1];
			ObsType3=arrObsType[2].split(CHR_2)[1];
			ObsType4=arrObsType[3].split(CHR_2)[1];	
			ObsTypeID1=arrObsType[0].split(CHR_2)[0];
			ObsTypeID2=arrObsType[1].split(CHR_2)[0];
			ObsTypeID3=arrObsType[2].split(CHR_2)[0];
			ObsTypeID4=arrObsType[3].split(CHR_2)[0];	
		}else {
			$.messager.alert("提示", "先维护手卫生依从性调查职业字典再做调查", 'info');
			return;
		}
		var Columns=[[
			{ title: ObsType1+'<input class="textbox" id="ObsType1" style="display:inline;display:none;" value="'+ObsType1+'"/><input class="textbox" id="ObsTypeID1" style="display:inline;display:none;" value="'+ObsTypeID1+'"/>&nbsp;&nbsp;<input class="textbox" id="ObsNumber1" style="width:40px;display:inline;"/>', align: 'left', halign: 'center', colspan: 6 },
			{ title: ObsType2+'<input class="textbox" id="ObsType2" style="display:inline;display:none;" value="'+ObsType2+'"/><input class="textbox" id="ObsTypeID2" style="display:inline;display:none;" value="'+ObsTypeID2+'"/>&nbsp;&nbsp;<input class="textbox" id="ObsNumber2" style="width:40px;display:inline;"/>', align: 'left', halign: 'center', colspan: 6 },
			{ title: ObsType3+'<input class="textbox" id="ObsType3" style="display:inline;display:none;" value="'+ObsType3+'"/><input class="textbox" id="ObsTypeID3" style="display:inline;display:none;" value="'+ObsTypeID3+'"/>&nbsp;&nbsp;<input class="textbox" id="ObsNumber3" style="width:40px;display:inline;"/>', align: 'left', halign: 'center', colspan: 3 },
			{ title: ObsType4+'<input class="textbox" id="ObsType4" style="display:inline;display:none;" value="'+ObsType4+'"/><input class="textbox" id="ObsTypeID4" style="display:inline;display:none;" value="'+ObsTypeID4+'"/>&nbsp;&nbsp;<input class="textbox" id="ObsNumber4" style="width:40px;display:inline;"/>', align: 'left', halign: 'center', colspan: 3 }
		], [
			{ field: 'Num1', title: '时机', width: 40, align: 'center' },
			{ field: 'Val11', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
				return CreatForm1(row.Cmp1, value);
				}
			},
			{ field: 'Val12', title: '手卫生行为', width: 90, align: '',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp1, value);
				}
			},
			{ field: 'Num2', title: '时机', width: 40, align: 'center' },
			{
				field: 'Val21', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
					return CreatForm1(row.Cmp2, value);
				}
			},
			{ field: 'Val22', title: '手卫生行为', width: 90, align: '',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp2, value);
				}
			},
			{ field: 'Num3', title: '时机', width: 40, align: 'center' },
			{ field: 'Val31', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
					return CreatForm1(row.Cmp3, value);
				}
			},
			{ field: 'Val32', title: '手卫生行为', width: 90, align: ' ',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp3, value);
				}
			},
			{ field: 'Num4', title: '时机', width: 40, align: 'center' },
			{ field: 'Val41', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
					return CreatForm1(row.Cmp4, value);
				}
			},
			{ field: 'Val42', title: '手卫生行为', width: 90, align: '',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp4, value);
				}
			},
			{ field: 'Num5', title: '时机', width: 40, align: 'center' },
			{ field: 'Val51', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
					return CreatForm1(row.Cmp5, value);
				}
			},
			{ field: 'Val52', title: '手卫生行为', width: 90, align: '',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp5, value);
				}
			},
			{ field: 'Num6', title: '时机', width: 40, align: 'center' },
			{field: 'Val61', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
					return CreatForm1(row.Cmp6, value);
				}
			},
			{field: 'Val62', title: '手卫生行为', width: 90, align: '',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp6, value);
				}
			}
		]]
	}else {
		//版本2
		var Columns=[[
			{ title: $g('职业')+'&nbsp;&nbsp;<input class="hisui-combobox textbox" id="ObsType1" style="width:100px;display:inline;"/><span style="margin-left:10px;">'+$g("姓名")+'</span>&nbsp;&nbsp;<input class="textbox" id="ObsName1" style="width:110px;display:inline;"/>', align: 'left', halign: 'center', colspan: 4 },
			{ title: $g('职业')+'&nbsp;&nbsp;<input class="hisui-combobox textbox" id="ObsType2" style="width:100px;display:inline;"/><span style="margin-left:10px;">'+$g("姓名")+'</span>&nbsp;&nbsp;<input class="textbox" id="ObsName2" style="width:110px;display:inline;"/>', align: 'left', halign: 'center', colspan: 4 },
			{ title: $g('职业')+'&nbsp;&nbsp;<input class="hisui-combobox textbox" id="ObsType3" style="width:100px;display:inline;"/><span style="margin-left:10px;">'+$g("姓名")+'</span>&nbsp;&nbsp;<input class="textbox" id="ObsName3" style="width:110px;display:inline;"/>', align: 'left', halign: 'center', colspan: 4 }
		], [
			{ field: 'Num1', title: '时机', width: 50, align: 'center' },
			{ field: 'Val11', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
					return CreatForm1(row.Cmp1, value);
				}
			},
			{field: 'Val12', title: '手卫生行为', width: 100, align: '',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp1, value);
				}
			},
			{field: 'Val13', title: '不正确原因', width: 150, align: '',
				formatter: function (value, row, index) {
					return CreatForm3(row.Cmp1, value);
				}
			},
			{ field: 'Num2', title: '时机', width: 50, align: 'center' },
			{field: 'Val21', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
					return CreatForm1(row.Cmp2, value);
				}
			},
			{ field: 'Val22', title: '手卫生行为', width: 100, align: '',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp2, value);
				}
			},
			{field: 'Val23', title: '不正确原因', width: 150, align: '',
				formatter: function (value, row, index) {
					return CreatForm3(row.Cmp2, value);
				}
			},
			{ field: 'Num3', title: '时机', width: 50, align: 'center' },
			{field: 'Val31', title: '指征', width: 100, align: 'center',
				formatter: function (value, row, index) {
					return CreatForm1(row.Cmp3, value);
				}
			},
			{field: 'Val32', title: '手卫生行为', width: 100, align: ' ',
				formatter: function (value, row, index) {
					return CreatForm2(row.Cmp3, value);
				}
			},
			{field: 'Val33', title: '不正确原因', width: 150, align: '',
				formatter: function (value, row, index) {
					return CreatForm3(row.Cmp3, value);
				}
			}
		]]
	}
	
	 obj.gridHandHyReg = $HUI.datagrid("#gridHandHyReg", {
		fit: true,
		iconCls: "icon-resort",
		toolbar: (obj.RegID ?'':'#ToolBar'),
		headerCls: 'panel-header-gray',
		singleSelect: true,
		loadMsg: '数据加载中...',
		nowrap: true, fitColumns: true,
		url: $URL,
		queryParams: {
			ClassName: "DHCHAI.IRS.HandHyRegSrv",
			QueryName: "QryHandHyReg",
			aLocID: "",
			aCheckDate: "",
			aObsPageID: "",
			aObsMethodID: ""
		},
		columns: Columns,
		onLoadSuccess:function(data){
			if (ServerObj.RegVer!='2') {
				$.parser.parse(".datagrid-body"); // 解析
				if (data.total>0) {
					var RegCntList = $m({
						ClassName: "DHCHAI.IRS.HandHyRegSrv",
						MethodName: "GetCntByReg",
						aRegID: (obj.RegID ? obj.RegID:obj.HandRegID)
					}, false);
					
					if (RegCntList) {
					    var ObsNumber1=RegCntList.split(",")[0];
						var ObsNumber2=RegCntList.split(",")[1];
						var ObsNumber3=RegCntList.split(",")[2];
						var ObsNumber4=RegCntList.split(",")[3];
						$("#ObsNumber1").val(ObsNumber1);
						$("#ObsNumber2").val(ObsNumber2);
						$("#ObsNumber3").val(ObsNumber3);
						$("#ObsNumber4").val(ObsNumber4);
					}
				}
			} else {		
				Common_ComboDicID("ObsType1","HandHyObsType",1);
				Common_ComboDicID("ObsType2","HandHyObsType",1);
				Common_ComboDicID("ObsType3","HandHyObsType",1);
				Common_LookupToDoc("ObsName1");
				Common_LookupToDoc("ObsName2");
				Common_LookupToDoc("ObsName3");
				$.parser.parse(".datagrid-body"); // 解析
				var len =data.total;
				if (len>0) {
					$("#ObsType1").combobox("setValue",data.rows[0].Type1);
					$("#ObsType2").combobox("setValue",data.rows[0].Type2);
					$("#ObsType3").combobox("setValue",data.rows[0].Type3);
					$("#ObsName1").lookup("setText",data.rows[0].Name1);
					$("#ObsName2").lookup("setText",data.rows[0].Name2);
					$("#ObsName3").lookup("setText",data.rows[0].Name3);
					
					for(i=0;i<len;i++) {
						var rowsData = data.rows[i];
						for(j=1;j<6;j++) {
							var Item = rowsData['Cmp'+j];
							if (!Item) continue;
							obj.CheckValue(Item);
						}
					}
				}
			}
		}
	});

	$(".datagrid-cell-group").css("height", "40px");
	$(".datagrid-cell-group").css("padding-top", "10px");
	
	//不正确与不正确原因选择控制
	obj.CheckValue =function(cmp) {	
		$('#'+cmp+'-I4').checkbox({  
			onChecked:function(e,value){
				$HUI.checkbox("input[name="+cmp+"-I5]").uncheck();
				$("input[name="+cmp+"-I5]").checkbox('disable');
			},onUnchecked:function(e,value){
				$("input[name="+cmp+"-I5]").checkbox('enable');
			}
		});
		var arrItemStr = obj.ItemStr2.split('^');
		var arrItem0 = arrItemStr[3].split('||');
		var arrItemStr2 = obj.ItemStr3.split('^');
		var arrItem2 = arrItemStr2[0].split('||');
		$('#'+cmp+'-I2' + '-' + arrItem0[0]).radio({
			onChecked:function(e,value){
				$HUI.checkbox("input[name="+cmp+"-I5"+"]").uncheck();
				$("input[name="+cmp+"-I5"+"]").checkbox('disable');
				$('#'+cmp+'-I5' + '-' + arrItem2[0]).checkbox('enable');
				$('#'+cmp+'-I5' + '-' + arrItem2[0]).checkbox('setValue',true); //手卫生行为如果选择"无"，那么后面就只能选"未执行"，其他3个不能选
			},onUnchecked:function(e,value){
				$("input[name="+cmp+"-I5"+"]").checkbox('enable');
				$('#'+cmp+'-I5' + '-' + arrItem2[0]).checkbox('setValue',false);
			}
		});
		var CheckFlg=$('#'+cmp+'-I4').is(':checked');
		if (CheckFlg) {
			$("input[name="+cmp+"-I5]").checkbox('disable');
		}
		var CheckFlg=$('#'+cmp+'-I2' + '-' + arrItem0[0]).is(':checked');
		if (CheckFlg) {
				$HUI.checkbox("input[name="+cmp+"-I5"+"]").uncheck();
				$("input[name="+cmp+"-I5"+"]").checkbox('disable');
				$('#'+cmp+'-I5' + '-' + arrItem2[0]).checkbox('enable');
				$('#'+cmp+'-I5' + '-' + arrItem2[0]).checkbox('setValue',true);
		}
		//不正确添加不正确原因
		$("input[name="+cmp+"-I5]").checkbox({  
			onChecked:function(e,value){
				var Label = Common_CheckboxLabel(cmp+"-I5");
				if(Label.indexOf($g("其他"))>-1){
					//显示输入框
					$('#'+cmp+'-Other').css("display","block");
					}
			},onUnchecked:function(e,value){
				var Label = Common_CheckboxLabel(cmp+"-I5");
				if(Label.indexOf($g("其他"))==-1){
					//隐藏输入框
					$('#'+cmp+'-Other').css("display","none");
					$('#'+cmp+'-Other').val("");
					}

			}
		});		

	}

		
	InitHandHyRegWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
