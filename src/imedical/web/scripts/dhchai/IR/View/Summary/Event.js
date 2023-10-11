//页面Event
function InitSummaryWinEvent(obj) {
	refreshGridView();
	//加载主表内容
	function refreshGridView() {
		// 生成空白视图表格
		var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv", "QryInfViewTitle", PaadmID, obj.column, obj.CurrNo);
		if (!runQuery) {
			//layer.alert('上一页已无数据！');
			layer.msg('上一页已无数据！', { icon: 2 });
			return;
		} else {
			if (runQuery.record.length == 0) {
				obj.CurrNo = obj.CurrNo - 1;
				//layer.alert('上一页已无数据！');
				layer.msg('上一页已无数据！', { icon: 2 });
				return;
			}
			obj.DateFrom = "";
			obj.DateTo = "";
			obj.AdmDays = 0;    //住院天数
			//obj.ViewIcon    = [];	//图例
			obj.Viewtitle = [];	//表头
			obj.ViewResult = [];	//视图数据
			obj.Viewtitle = runQuery.record;
			//刷新前清空
			if (obj.gridItemView != undefined) {
				obj.gridItemView.clear().draw();
				obj.gridItemView.destroy();
			}
			obj.columnList = [];
			for (var i = 0; i <= obj.Viewtitle.length; i++) {
				if (i == 0) {
					var objC = {};
					objC["title"] = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日 期&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';//&nbsp;解决IE下出现表头无法对齐
					objC["data"] = "column_Data_" + i;
					obj.columnList.push(objC);
				} else {
					var objC = {};
					objC["title"] = obj.Viewtitle[i - 1].DateShow;
					var TransFlag = obj.Viewtitle[i - 1].TransFlag;
					if ((TransFlag == '1') || (TransFlag == '3')) {
						objC["title"] = obj.Viewtitle[i - 1].DateShow + '<br>' + '<span style="display:block;width:40px;overflow:hidden;background-color:#00FFFF;font-size:75%;">' + obj.Viewtitle[i - 1].TransLoc + '</span>';
					}
					objC["data"] = "column_Data_" + i;
					obj.columnList.push(objC);
				}
			};

			// 生成空白表格数据
			obj.dataSet = [];
			for (var i = -1; i < obj.ViewIcon.length; i++) {
				// 表格内容增加显示入院天数
				if (i == -1) {
					var desc = "入院天数";
					var tmpMap = { 'column_Data_0': desc }
					for (var j = 0; j < obj.Viewtitle.length; j++) {
						if (obj.Viewtitle[j].AdmDays != "") {
							var AdmDays = +(obj.Viewtitle[j].AdmDays);
							if (AdmDays > obj.AdmDays) obj.AdmDays = AdmDays;
							var evalStr = 'tmpMap.column_Data_' + (j + 1) + '=' + obj.Viewtitle[j].AdmDays;
						} else {
							var evalStr = 'tmpMap.column_Data_' + (j + 1) + '=""';
						}
						eval(evalStr);
					}
				} else {
					var desc = obj.ViewIcon[i].desc;
					var tmpMap = { 'column_Data_0': desc };
					for (var j = 0; j < obj.Viewtitle.length; j++) {
						var evalStr = 'tmpMap.column_Data_' + (j + 1) + '=""';
						eval(evalStr);
					}
				}
				obj.dataSet.push(tmpMap);
			};
			obj.gridItemView = $("#gridItemView").DataTable({
				dom: 'rt<"row">'
				, columns: obj.columnList
				, data: obj.dataSet
				, ordering: false
				, paging: false
				, fixedColumns: true
				, scrollX: true
			});

			// 视图表格td、th添加id
			$("#gridItemView tbody").find("tr").each(function (i) {
				$(this).children("td").each(function (j) {
					$(this).attr("id", "td_view_" + i + "_" + j);
				})
			});
		}

		//图标代码、位置、图标路径的对照关系
		var iconIndexMap = {};
		for (var i = 0; i < obj.ViewIcon.length; i++) {
			var code = obj.ViewIcon[i].code;
			var index = obj.ViewIcon[i].index
			var evalstr = "iconIndexMap." + code + "=" + index;
			eval(evalstr);
		}
		var iconSrcMap = {};
		for (var i = 0; i < obj.ViewIcon.length; i++) {
			var code = obj.ViewIcon[i].code;
			var src = obj.ViewIcon[i].src;
			var evalstr = "iconSrcMap." + code + "='" + src + "'";
			eval(evalstr);
		}

		//根据后台数据改变已经渲染表格样式
		var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv", "QryInfViewResult", PaadmID);
		var DateIndex = obj.Viewtitle[0].DateIndex;
		if (!runQuery) {
			return;
		} else {
			obj.ViewResult = runQuery.record;

			for (var i = 0; i < obj.ViewResult.length; i++) {
				var ItemCode = obj.ViewResult[i].IVItemCode;
				var ItemDate = obj.ViewResult[i].IVDate;
				var IVFlag = obj.ViewResult[i].IVFlag;
				var IVResult = obj.ViewResult[i].IVResult;
				var IVDateType = obj.ViewResult[i].IVDateType;
				var RID=""//报告ID
				if(ItemCode=="HAI"){
				    //IVResult = obj.ViewResult[i].IVResult.split('^')[0].split("|")[0];
                    RID= obj.ViewResult[i].IVResult.split('^')[0].split("|")[1];
				}
				var KSS = "";
				//判断抗生素最高等级
				if (ItemCode == "ANT") {
					if (IVResult.indexOf("KSS3") > -1) {
						KSS = "KSS3";
					} else if (IVResult.indexOf("KSS2") > -1) {
						KSS = "KSS2";
					} else {
						KSS = "KSS1";
					}
				}

				var dayMaxTmp = 0; //当日最高体温
				var arryIVResult = IVResult.split('^');
				for (var j = 0; j < arryIVResult.length; j++) {
					if (arryIVResult[j] == "") continue;
					if (j == 0) {
						if(ItemCode == "HAI"){
							IVResult = arryIVResult[j].split("|")[0];
						}
						else{
							IVResult = arryIVResult[j];
						}
					} else {
						if(ItemCode == "HAI"){
							IVResult = IVResult + '\n' + arryIVResult[j];
						}
						else{
							IVResult = IVResult + '\n' + arryIVResult[j].split("|")[0];
						}
						
					}

					//获取最高体温
					if (ItemCode == 'TMP') {
						var TempTmp = arryIVResult[j].split(' ')[0];
						TempTmp = TempTmp.replace(/[^\d.]/g, ''); //非数字或小数替换为空
						TempTmp = parseFloat(TempTmp);

						if (dayMaxTmp < TempTmp) dayMaxTmp = TempTmp;
					}
				}
				if (IVFlag == 0) continue;
				//获取图标路径、行号、列号
				var evalstr = "var row = iconIndexMap." + ItemCode;
				eval(evalstr);
				var evalstr = "var src = iconSrcMap." + ItemCode;
				eval(evalstr);
				var column = ItemDate - DateIndex + 1;
				if (ItemCode == "HAI" && IVDateType == 3) {
					src = '../scripts/dhchai/img/院感报告-实.png';
				}

				if (ItemCode == "ANT")		//抗生素特殊处理
				{
					var IVRows = obj.ViewResult[i].IVRows;	//抗生素行号为后台结果
					var eleID = 'td_view_' + (IVRows - 1) + '_' + column;
				} else {
					var eleID = 'td_view_' + (row - 1) + '_' + column;
				}

				/***************报告日期显示不同的图标 start*******************/
				var RepSrc = ''; //报告日期的src
				switch (ItemCode) {
					case 'RBT':
						RepSrc = '../scripts/dhchai/img/血常规-线.png';
						break;
					case 'RUT':
						RepSrc = '../scripts/dhchai/img/尿常规-线.png';
						break;
					case 'ROT':
						RepSrc = '../scripts/dhchai/img/其他常规-线.png';
						break;
					case 'MDR':
						RepSrc = '../scripts/dhchai/img/多重耐药菌-线.png';
						break;
					case 'BUG':
						RepSrc = '../scripts/dhchai/img/细菌-线.png';
						break;
				}
				/***************报告日期显示不同的图标 End*******************/


				//添加图标
				if (ItemCode == "ANT") {
					$("#" + eleID).attr("title", IVResult);
					//抗生素背景
					if (KSS == "KSS1") {
						$("#" + eleID).css("background-color", obj.ViewBackColor[0][1]);
					} else if (KSS == "KSS2") {
						$("#" + eleID).css("background-color", obj.ViewBackColor[1][1]);
					} else {
						$("#" + eleID).css("background-color", obj.ViewBackColor[2][1]);
					}

				} else if (ItemCode == 'TMP') {
					var html = '<span id="tip" title="' + IVResult + '" style="color:red;">' + dayMaxTmp + '</span>';
					$("#" + eleID).append(html);
				}else if ((ItemCode == 'BUG')&&(IVDateType == 3)) {
					//送检阴性结果处理
					//border-bottom: solid 3px #1a5cd3;
					$("#" + eleID).attr("title", IVResult);
					$("#" + eleID).css("border-bottom", "solid 3px #00B050");
				} else {
					//HAI
					//是否已经添加图标
					if ($("#" + eleID).find('span').length) {
						//替换图片
						$("#" + eleID + '>span>img').attr("src", src);
						//修改提示内容
					    var oldTitle = $("#" + eleID + '>span').attr("title");
						var Title = oldTitle + '\n' + IVResult;
						//Title = IVResult;
						$("#" + eleID + '>span').attr("title", Title);
					} else { //当前没有图标
						if (IVDateType == 2) {
							src = RepSrc;
						}
						var html = '<span id="tip" title="' + IVResult + '">' + '<img src = "' + src + '"></img>' + '</span>';
						if ((src!="")&&(src!=undefined)&&(src.indexOf('../scripts/dhchai/img/院感报告')>-1 )) {
							var html = '<span id="tip" title="' + IVResult + '">' + '<img src = "' + src + '" id="'+RID+'"></img>' + '</span>';
						}
						$("#" + eleID).append(html);
					}
				}
			}
		}

		// 视图表格使用滚动条插件
		$("#gridItemView_wrapper .dataTables_scrollBody").mCustomScrollbar({
			// scrollButtons: { enable: true },
			theme: "dark-thick",
			axis: "x",
			callbacks: {
				whileScrolling: function () {
					$('#gridItemView_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left);
				}
			}
		});

		// 视图滚动条默认滚动到最右边
		setTimeout(function () {
			if (obj.AdmDays > 30) {
				$("#gridItemView_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo", $("#gridItemView tr td:last"));
			}
		}, 100);
		// 首次加载明细内容（视图时间内所有明细）
		obj.DateFrom = obj.Viewtitle[0].DateIndex;
		obj.DateTo = obj.Viewtitle[obj.Viewtitle.length - 1].DateIndex;
		refreshgridViewDetail();
		// 视图表头提示
		for (var i = 0; i < obj.Viewtitle.length; i++) {
			if (obj.Viewtitle[i].TransLoc == "") continue;
			var innerHtml = $("#gridItemView_wrapper th")[i + 1].innerHTML;
			$("#gridItemView_wrapper th")[i + 1].innerHTML = '';
			var html = '<span id="tip" title="' + obj.Viewtitle[i].TransLoc + '">' + innerHtml + '</span>';
			$($("#gridItemView_wrapper th")[i + 1]).append(html);
		}
	}
	// 重新加载明细列表
	function refreshgridViewDetail() {

		if (obj.gridViewDetail == null) {
			var scrollY = $("body").height() - $("#ItemViewDiv").height() - parseInt($("#ItemViewDiv").css("margin-top")) - parseInt($("#ItemViewDiv").css("margin-bottom")) - $("table.dataTable thead th").height() + 'px';
			obj.gridViewDetail = $("#gridViewDetail").DataTable({
				dom: 'rt'
				, ordering: false
				, autoWidth: false
				, paging: false
				, keys: true
				, scrollY: scrollY
				, order: [[0, "desc"]]
				, ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.CCInfViewSrv";
						d.QueryName = "QryInfViewDetail";
						d.Arg1 = PaadmID;
						d.Arg2 = obj.DateFrom;
						d.Arg3 = obj.DateTo;
						d.ArgCnt = 3;
					}
				}
				, columns: [
					{ "data": "ActDate" },
					{ "data": "DiagStr" },
					{ "data": "TreatStr" }
				]
				, drawCallback: function (settings) {
					$("#gridViewDetail").css("width", "100%");
				}
			});
		} else {
			obj.gridViewDetail.ajax.reload();
		}
		$("#gridViewDetail_wrapper .dataTables_scrollBody").mCustomScrollbar({
			// scrollButtons: { enable: true },
			theme: "dark-thick",
			axis: "y"
		});
	}
	obj.winOpenInfReport = function (ReportID) {
		if (!ReportID) return;
		var strUrl = "dhcma.hai.ir.inf.report.csp?1=1&ReportID=" + ReportID + "&AdminPower=1&2=2";
		//	var ratio = detectZoom();
		//var PageWidth = Math.round(1320 * ratio);
		//var page = websys_createWindow(strUrl, "", "width=" + PageWidth + ",height=95%");
		var page = websys_createWindow(strUrl, "", "width=80%,height=80%");
		//--关闭前刷新查询列表
		var Loop = setInterval(function () {
			if (page.closed) {
				clearInterval(Loop);
				//刷新列表
				refreshGridView();
			}
		});

	}
	//获取当前页面的缩放值
	function detectZoom() {
		var ratio = 1;
		if (BrowserVer == "isChrome") {   //医为浏览器为 Chrome 49
			var userAgent = navigator.userAgent;
			var ChromePos = userAgent.indexOf("Chrome");  //Chrome定位
			var ChromeStr = userAgent.substr(ChromePos);  //Chrome串
			var ChromeArr = ChromeStr.split(" ");
			var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome版本
			if (ChromeVer <= 58) {
				ratio = window.devicePixelRatio;
			}
		}
		return ratio;
	}
	// 视图图标点击事件
	obj.gridItemView.on('click', 'td', function () {

		var colInd = obj.gridItemView.cell(this).index().column;
		var rowInd = obj.gridItemView.cell(this).index().row;		
		if (($("#td_view_" + rowInd + "_" + colInd + ":has(img)").length == 0) && (!$("#td_view_" + rowInd + "_" + colInd).attr("title"))) return;   //td是否有img元素或title提示
	    //如果照片是院感，则点击加载新页面
		if (($("#td_view_" + rowInd + "_" + colInd + ":has(img)").length > 0) && ($("#td_view_" + rowInd + "_" + colInd).find("[class='mCS_img_loaded']").attr('src').indexOf("../scripts/dhchai/img/院感报告") >-1)) {
		var RID=$("#td_view_" + rowInd + "_" + colInd).find("[class='mCS_img_loaded']").attr('id')
			obj.winOpenInfReport(RID);
		}
		var DateIndex = obj.Viewtitle[0].DateIndex;
		var ViewDate = parseInt(DateIndex) + parseInt(colInd) - 1;
		//加载明细列表 
		obj.DateFrom = ViewDate - 7;
		obj.DateTo = ViewDate + 7;
		refreshgridViewDetail();
	});

	// 视图图标点击事件
	$('#previous').on('click', function () {
		obj.CurrNo = obj.CurrNo + 1;
		refreshGridView();
	});
	// 视图图标点击事件
	$('#next').on('click', function () {
		if (obj.CurrNo == 1) {
			//alert('下一页已无数据！');
			//layer.alert('下一页已无数据！');
			layer.msg('下一页已无数据！', { icon: 2 });
			return;
		}
		obj.CurrNo = obj.CurrNo - 1;
		refreshGridView();
	});
}
