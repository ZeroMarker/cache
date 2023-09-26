//页面Gui
function InitHandHyRegWin(){
	var obj = new Object();
	
	/* 渲染下拉框 */
	$("#cboHospital").data("param",$.LOGON.HOSPID);
	$.form.SelectRender('cboHospital');
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	$("#cboObsLoc").data("param",$.form.GetValue("cboHospital")+"^^I^W^1");
	$.form.SelectRender("cboObsLoc");
	$.form.SelectRender("cboObsPage");
	$("#cboObsPage option:selected").next().attr("selected", true)
	$("#cboObsPage").select2();
	$.form.SetValue("txtObsUser",$.LOGON.USERDESC);
	// 给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		// 获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboObsLoc").data("param",id+"^^I^W^1");
		$.form.SelectRender("cboObsLoc");	
	});
	$("#cboObsLoc").on("select2:select", function (e) {  // 默认选中科室加载第一页
		$.form.SelectRender("cboObsPage");
		$("#cboObsPage option:selected").next().attr("selected", true)
		$("#cboObsPage").select2();
	});
	
	$.form.DateTimeRender('ObsDate',$.form.GetCurrDate('-'));
	
	// 671||病人前^672||操作前^673||体液后^674||病人后^675||环境后
	obj.ItemStr1 = $.Tool.RunServerMethod("DHCHAI.IRS.HandHyRegSrv","GetHandHyItems","HandHyOpportunity");
	
	// 676||手消^677||肥皂和水^678||无
	obj.ItemStr2=$.Tool.RunServerMethod("DHCHAI.IRS.HandHyRegSrv","GetHandHyItems","HandHyFacilities");
	
	function CreatForm1(cmp,val){
        var htmlstr = ''
		if (!cmp) return htmlstr;
		htmlstr += '<div class="box">'
		htmlstr += '    <ul class="list-group" id="' + cmp + '">'
		
		var arrVal=val.split('!!');
		var val=arrVal[0];
		var arrValue = val.split(',');
		
		var arrItemStr = obj.ItemStr1.split('^');
		var itemId =  cmp + '-I1'
		for (var ind=0; ind<arrItemStr.length; ind++) {
			var arrItem = arrItemStr[ind].split('||');
			var checked = (arrValue.indexOf(arrItem[0])<0 ? "" : "checked");
			htmlstr += '<li class="input-group">'
			htmlstr += '	<span><input type="checkbox" name="' + itemId + '" id="' + itemId + '-' + arrItem[0] + '" ' + checked + '></span>' + arrItem[1]
			htmlstr += '</li>'
		}
		
		htmlstr += '    </ul>'
		htmlstr += '</div>'
		return htmlstr;
	}
	
	function CreatForm2(cmp,val){
        var htmlstr = ''
		if (!cmp) return htmlstr;
		htmlstr += '<div class="box">'
		htmlstr += '    <ul class="list-group" id="' + cmp + '">'
		
		var arrVal=val.split('!!');
		var val=arrVal[0];
		var arrValue = val.split('^');
		var arrItemStr = obj.ItemStr2.split('^');
		var itemId =  cmp + '-I2'
		for (var ind=0; ind<arrItemStr.length; ind++) {
			var arrItem = arrItemStr[ind].split('||');
			var checked = (arrValue.indexOf(arrItem[0])<0 ? "" : "checked");
			htmlstr += '<li class="input-group">'
			htmlstr += '	<span><input type="radio" name="' + itemId + '" id="' + itemId + '-' + arrItem[0] + '" ' + checked + '></span>' + arrItem[1]
			htmlstr += '</li>'
		}
		
		var val=arrVal[1];
		var itemId =  cmp + '-I3'
		var checked = (val!=='1' ? "" : "checked");
		htmlstr += '<li class="input-group">'
		htmlstr += '	<span><input type="checkbox" id="' + itemId + '" ' + checked + '></span>戴手套'
		htmlstr += '</li>'
		
		var val=arrVal[2];
		var itemId = cmp + '-I4'
		var checked = (val!=='1' ? "" : "checked");
		htmlstr += '<li class="input-group">'
		htmlstr += '	<span><input type="checkbox" id="' + itemId + '" ' + checked + '></span>正确'
		htmlstr += '</li>'
		
		htmlstr += '    </ul>'
		htmlstr += '</div>'
		return htmlstr;
	}
	
	//系统参数列表
	obj.gridHandHyReg = $("#gridHandHyReg").DataTable({
		dom: 'rt',
		//select: 'single',
		paging: false,
		ordering: false,
		info: false,
		processing: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.HandHyRegSrv";
				d.QueryName = "QryHandHyReg";
				d.Arg1 = $.form.GetValue("cboObsLoc");
				d.Arg2 = $.form.GetValue("ObsDate");
				d.Arg3 = $.form.GetValue("cboObsPage");
				d.ArgCnt = 3;
			}
		},
		"columns": [
			{"data": "Num1"},
			{"data": "Val11",
				"render": function (data, type, row) {
					return CreatForm1(row['Cmp1'],data);
				}
			},
			{"data": "Val12",
				"render": function (data, type, row) {
					return CreatForm2(row['Cmp1'],data);
				}
			},
			{"data": "Num2"},
			{"data": "Val21",
				"render": function (data, type, row) {
					return CreatForm1(row['Cmp2'],data);
				}
			},
			{"data": "Val22", 
				"render": function (data, type, row) {
					return CreatForm2(row['Cmp2'],data);
				}
			},
			{"data": "Num3"},
			{"data": "Val31",
				"render": function (data, type, row) {
					return CreatForm1(row['Cmp3'],data);
				}
			},
			{"data": "Val32", 
				"render": function (data, type, row) {
					return CreatForm2(row['Cmp3'],data);
				}
			},
			{"data": "Num4"},
			{"data": "Val41",
				"render": function (data, type, row) {
					return CreatForm1(row['Cmp4'],data);
				}
			},
			{"data": "Val42", 
				"render": function (data, type, row) {
					return CreatForm2(row['Cmp4'],data);
				}
			},
			{"data": "Num5"},
			{"data": "Val51",
				"render": function (data, type, row) {
					return CreatForm1(row['Cmp5'],data);
				}
			},
			{"data": "Val52", 
				"render": function (data, type, row) {
					return CreatForm2(row['Cmp5'],data);
				}
			},
			{"data": "Num6"},
			{"data": "Val61",
				"render": function (data, type, row) {
					return CreatForm1(row['Cmp6'],data);
				}
			},
			{"data": "Val62", 
				"render": function (data, type, row) {
					return CreatForm2(row['Cmp6'],data);
				}
			}
		],
		drawCallback: function (settings) {
			// 渲染checkbox
			$.form.CheckBoxRender();
			$.form.iCheckRender();
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitHandHyRegWinEvent(obj);
	return obj;
}