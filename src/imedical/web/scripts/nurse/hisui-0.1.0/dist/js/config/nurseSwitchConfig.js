/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description 护理病历开关配置
 */
$(function() { 
	var GLOBAL = {
		HospEnvironment: true,
		UpdateElements: $cm({ClassName:'NurMp.NursingRecordsConfig',MethodName:'getSwitchElements',Type:'Update'},false),
		EditElements: $cm({ClassName:'NurMp.NursingRecordsConfig',MethodName:'getSwitchElements',Type:'Edit'},false),
		CAElements: $cm({ClassName:'NurMp.NursingRecordsConfig',MethodName:'getSwitchElements',Type:'CA'},false),
		FTPElements: $cm({ClassName:'NurMp.NursingRecordsConfig',MethodName:'getSwitchElements',Type:'FTP'},false)
	};
	/**
	 * @description 初始化界面
	 */
	function initUI() {
		initCondition();
		$('#tabConfig').tabs({
			onSelect: function (title,index) {
				getConfiguration(index);
			}
		});
		getConfiguration(0);
		listenEvents();
	}
	/**
	 * @description 获取院区ID
	 */
	function getHospitalID() {
		return "";  //session['LOGON.HOSPID'];
//		return GLOBAL.HospEnvironment == true ? $HUI.combogrid('#_HospList').getValue() : session['LOGON.HOSPID'];
	}
	/**
	 * @description 初始化医院
	 */
	function initHosp(){
		var param = session['LOGON.USERID'] + '^' + session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + session['LOGON.HOSPID'];
		var hospComp = GenHospComp("Nur_IP_NursingRecordsConfig",param);  
		hospComp.options().onSelect = function(){
			getConfiguration();
		}
	}
	/**
	 * @description 初始化条件
	 */
	function initCondition() {
		/*
		if (typeof GenHospComp == "undefined") {
			GLOBAL.HospEnvironment = false;
		}
		if(GLOBAL.HospEnvironment){
			initHosp();
		}else{
			var hospDesc=tkMakeServerCall("NurMp.DHCNURTemPrintLInk","GetHospDesc",session['LOGON.HOSPID'])
			$("#_HospList").val(hospDesc)
			$('#_HospList').attr('disabled',true);
		}
		*/
		$("input[id*='Backcolor']").color({
			editable: false,
			onChange: function(value){
			}
		})
		$HUI.combobox('#KnowCateExpandFlag', {
			valueField: 'id',
			textField: 'text',
			value: 'none',
			data:[
				{id:'C', text:"全部收缩"},
				{id:'O', text:"全部展开"},
				{id:'P1', text:"展开一级目录"}
			], 
		});
	    $HUI.combobox('#TabletValue', {
			valueField: 'id',
			textField: 'text',
			value: 'none',
			data:[
				{id:'none', text:"无"},
				{id:'DCDSV1', text:"信手书1.0"},
				{id:'DCDSV2', text:"信手书2.0"}
			], 
			onSelect: function(record) {
				if (record.id != 'none') {
					$('#panelPatientPicSizeSet').css('display','block');
				}else{
					$('#panelPatientPicSizeSet').css('display','none');
				}
			},
		});
	}
	/**
	 * @description 查询配置信息
	 */
	function getConfiguration(index) {
		$cm({
			ClassName:"NurMp.NursingRecordsConfig",
			MethodName:"getConfiguration",
			HospitalID: '',
			Index: index
		},function(jsonData){
			for (var item in jsonData) {
		        var domID = '#' + item;
		        var itemValue = jsonData[item];
		        //if (domID === '#CATabletValue') {
		        var domType = $(domID).attr('class');
		        if (!!domType) {
			        if (item.indexOf('Backcolor') > -1) {
				    	$(domID).color('setValue',itemValue);
				    }else{
			        	if (domType.indexOf('combobox') > -1) {
				        	$(domID).combobox('setValue', itemValue);
				        } else if (domType.indexOf('textbox') > -1){
				        	$(domID).val(itemValue);
				        } else if (domType.indexOf('switchbox') > -1){
				        	var switchVal = itemValue == true ? true : false;
				        	$(domID).switchbox('setValue', switchVal);
				        }
					}
		        } else if (domID.indexOf('Group') > -1) {
		        	var name = $(domID).selector.split('#')[1];
		        	$HUI.radio("input[name='" + name + "']").setValue(false);
		        	if (!!itemValue) {
			        	var arrValue = itemValue.split(/,/);
			        	$.each(arrValue, function(index, value) {
			        		$HUI.radio("input[name='" + name + "'][value='" + value + "']").setValue(true);
				        });
		        	}
		        } else {
		        	var name = $(domID).selector.split('#')[1];
		        	$HUI.radio("input[name='" + name + "']").setValue(false);
		        	$HUI.radio("input[name='" + name + "'][value='" + itemValue + "']").setValue(true);
		        }
		    }
		    $m({
				ClassName:"CA.DigitalSignatureService",
				MethodName:"IsCACTLoc",
				CTLocID: session['LOGON.CTLOCID']
			},function(CAFlag){
				if (CAFlag === '0') {
					// $('#CASwitchFlag').switchbox('setActive',false);
					// $('#CAPictureFlag').switchbox('setActive',false);
					// $('#CATabletValue').combobox('disable');
				}
			});
			//listenEvents();
		});
	}
	
	/**
	 * @description 保存护理病历版本升级标志
	 */
	function saveUpdate() {
		var config = getElementValue('UpdateElements',false,false);
		$cm({
			ClassName: "NurMp.Config",
			MethodName: "ConfigSet",
			parr: config
		},function(ret){
			if (parseInt(ret) > 0) {
				$.messager.popover({ msg: '保存成功!', type: 'success' });
			} else {
				$.messager.popover({ msg: '保存失败!', type: 'error' });
			}
		});
	}
	/**
	 * @description 保存护理病历填写修改配置
	 */
	function saveWrite() {
		var templateParameters = getElementValue('EditElements',true,true);
		$cm({
			ClassName: "NurMp.NursingRecordsConfig",
			MethodName: "save",
			parr: templateParameters,
			HospitalID: '',
			DeptType: 'I'
		},function(ret){
			if (parseInt(ret) == 0) {
				$.messager.popover({ msg: '保存成功!', type: 'success' });
			} else {
				$.messager.popover({ msg: '保存失败!' + ret, type: 'error' });
			}
		});
	}
	/**
	 * @description 保存护理病历CA配置
	 */
	function saveCA() {
		var CAParameters = getElementValue('CAElements',true,true);
		$cm({
			ClassName: "NurMp.CA.Certification",
			MethodName: "save",
			parr: CAParameters,
			HospitalID: ''
		},function(ret){
			if (parseInt(ret) == 0) {
				$.messager.popover({ msg: '保存成功!', type: 'success' });
			} else {
				$.messager.popover({ msg: '保存失败!' + ret, type: 'error' });
			}
		});
	}
	/**
	 * @description 保存FTP设置
	 */
	function saveFtp() {
		if (!$('#FtpAddress').val().trim()) {
			$.messager.popover({ msg: 'Ftp地址不能为空!', type: 'error' });
			return;
		}
		if (!$('#FtpUserName').val().trim()) {
			$.messager.popover({ msg: 'Ftp用户名不能为空!', type: 'error' });
			return;
		}
		if (!$('#FtpPassWord').val()) {
			$.messager.popover({ msg: 'Ftp密码不能为空!', type: 'error' });
			return;
		}
		if (!$('#FtpPort').val().trim()) {
			$.messager.popover({ msg: 'Ftp端口不能为空!', type: 'error' });
			return;
		}
		if (!$('#FtpDealyTime').val().trim()) {
			$.messager.popover({ msg: 'Ftp延迟时间不能为空!', type: 'error' });
			return;
		}
		$.messager.confirm("提醒", "确定要修改吗?", function (r) {
			if (r) {	
				$cm({
					ClassName: "NurMp.RecordsBrowserFtpInfo",
					MethodName: "saveFtpInfo",
					IP: $('#FtpAddress').val().trim(),
					UserName: $('#FtpUserName').val().trim(),
					Password: $('#FtpPassWord').val(),
					Port: $('#FtpPort').val().trim(),
					DealyTime: $('#FtpDealyTime').val().trim(),
					HospitalID: ''
				},function(ret){
					if (parseInt(ret) == 0) {
						$.messager.popover({ msg: '保存成功!', type: 'success' });
					} else {
						$.messager.popover({ msg: '保存失败!  错误代码：' + ret, type: 'error' });
					}
				});
			}else{
				return;
			}
		});
	}
	/**
	 * @description 取各个元素值
	 */
	function getElementValue(moduleName, boolFlag, AtFlag) {
		var result = '';
		var elementArr = GLOBAL.UpdateElements;
		switch (moduleName) {
			case 'EditElements': elementArr = GLOBAL.EditElements; break;
			case 'CAElements': elementArr = GLOBAL.CAElements; break;
			case 'FTPElements': elementArr = GLOBAL.FTPElements; break;
			default: break;
		}
		$.each(elementArr,function(index,domID){
			var domVal = '';
			var domType = $('#' + domID).attr('class');
	        if (!!domType) {
		        if (domID.indexOf('Backcolor') > -1) {
			        domVal = $('#' + domID).color('getValue');
			    }else{
		        	if (domType.indexOf('combobox') > -1) {
			        	domVal = $('#' + domID).combobox('getValue');
			        } else if (domType.indexOf('textbox') > -1){
			        	domVal = $('#' + domID).val();
			        } else if (domType.indexOf('switchbox') > -1){
			        	domVal = $('#' + domID).switchbox('getValue');
			        	if (!boolFlag) {
							domVal = domVal ? '1' : '0';
						}
			        }
				}
	        } else if (domID.indexOf('Group') > -1){
		        $("input[name=" + domID + "]").each(function(index,item) {
			        if (item.checked) {
			            domVal = !!domVal ? domVal + ',' + item.value : item.value;
			        }
				});
	        }else{
		    	domVal = $("input[name=" + domID + "]:checked").val();
		    }
	        var parValue = domVal.toString();
	        if (AtFlag) {
	        	parValue =  domID + '@' + domVal.toString();
	        }
			result = result!='' ? result + '^' + parValue : parValue;
		});
		return result;
	}
	/**
	 * @description 事件监听
	 */
	function listenEvents() {
		setTimeout(function(){
			//页面加载
			var outpatEditVal = $('#OutPatientEditFlag').switchbox('getValue');
			var nurseCAVal = $('#SwitchFlag').switchbox('getValue');
			var puppetCAVal = $('#CAPuppet').switchbox('getValue');
			var tabletValue = $('#TabletValue').combobox('getValue');
			if (outpatEditVal) {
				$('.limitLabel').css('display','inline-block');
				$('#OutPatientEditDays').css('display','inline-block');
			}
			if (nurseCAVal) {
				$('#panelRealCA').css('display','block');
				$('#panelNursePicSizeSet').css('display','block');
			}else{
				$('#panelRealCA').css('display','none');
				$('#panelNursePicSizeSet').css('display','none');
			}	
			if (puppetCAVal) {
				$('#panelFakeCA').css('display','block');
				$('#panelNursePicSizeSet').css('display','block');
			}else{
				$('#panelFakeCA').css('display','none');
				$('#panelNursePicSizeSet').css('display','none');
			}	
			
			if (tabletValue != 'none') {
				$('#panelPatientPicSizeSet').css('display','block');
			}else{
				$('#panelPatientPicSizeSet').css('display','none');
			}	
			
			//切换
			$('#OutPatientEditFlag').switchbox('options').onSwitchChange = function(e,obj){
				if (obj.value) {
					$('.limitLabel').css('display','inline-block');
					$('#OutPatientEditDays').css('display','inline-block');
				}else{
					$('.limitLabel').css('display','none');
					$('#OutPatientEditDays').val('');
					$('#OutPatientEditDays').css('display','none');
				}
			};
			$('#SwitchFlag').switchbox('options').onSwitchChange = function(e,obj){
				if (obj.value) {
					$('#panelRealCA').css('display','block');
					$('#panelNursePicSizeSet').css('display','block');
				}else{
					if ($('#CAPuppet').switchbox('getValue')) {
						$('#panelRealCA').css('display','none');
					}else{
						$('#panelRealCA').css('display','none');
						$('#panelNursePicSizeSet').css('display','none');
					}
				}
			};
			$('#CAPuppet').switchbox('options').onSwitchChange = function(e,obj){
				if (obj.value) {
					$('#panelFakeCA').css('display','block');
					$('#panelNursePicSizeSet').css('display','block');
				}else{
					if ($('#SwitchFlag').switchbox('getValue')) {
						$('#panelFakeCA').css('display','none');
					}else{
						$('#panelFakeCA').css('display','none');
						$('#panelNursePicSizeSet').css('display','none');
					}
				}
			};
		
			$('#SignPWDSwitchFlag').switchbox('options').onSwitchChange = function(e,obj){
				if (!obj.value) {
					$('#SignPWDClassFunc').attr('disabled',true);	
				}else{
					$('#SignPWDClassFunc').attr('disabled',false);
				}
			};
		},2000);
		$('#btnSaveUpdate').bind('click',saveUpdate);
		$('#btnSaveWrite').bind('click',saveWrite);
		$('#btnSaveCA').bind('click',saveCA);
		$('#btnSaveFtp').bind('click',saveFtp);
	}
	
	
	initUI();
});