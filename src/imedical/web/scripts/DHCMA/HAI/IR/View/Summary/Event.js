//ҳ��Event
function InitSummaryWinEvent(obj) {
	refreshGridView();
	//������������
	function refreshGridView() {
		// ���ɿհ���ͼ���
		//var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv", "QryInfViewTitle", PaadmID, obj.column, obj.CurrNo);
		var runQuery =$cm({
				ClassName:"DHCHAI.IRS.CCInfViewSrv",
				QueryName:"QryInfViewTitle",
				aEpisodeID:PaadmID,
				aColumnCount:obj.column,
				aCurrNo:obj.CurrNo,
	        	rows:1000000
			},false);
		if (!runQuery) {
			//layer.alert('��һҳ�������ݣ�');
			//layer.msg('��һҳ�������ݣ�', { icon: 2 });
			$.messager.alert("ȷ��", $g("��һҳ�������ݣ�"), 'info');
			return;
		} else {
			if (runQuery.rows.length == 0) {
				obj.CurrNo = obj.CurrNo - 1;
				//layer.alert('��һҳ�������ݣ�');
				//layer.msg('��һҳ�������ݣ�', { icon: 2 });
				$.messager.alert("ȷ��", $g("��һҳ�������ݣ�"), 'info');
				return;
			}
			obj.DateFrom = "";
			obj.DateTo = "";
			obj.AdmDays = 0;    //סԺ����
			//obj.ViewIcon    = [];	//ͼ��
			obj.Viewtitle = [];	//��ͷ
			obj.ViewResult = [];	//��ͼ����
			obj.Viewtitle = runQuery.rows;
			//ˢ��ǰ���
			if (obj.gridItemView != undefined) {
				obj.gridItemView.clear().draw();
				obj.gridItemView.destroy();
			}
			obj.columnList = [];
			for (var i = 0; i <= obj.Viewtitle.length; i++) {
				if (i == 0) {
					var objC = {};
					objC["title"] = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+$g('�� ��')+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';//&nbsp;���IE�³��ֱ�ͷ�޷�����
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

			// ���ɿհױ������
			obj.dataSet = [];
			for (var i = -1; i < obj.ViewIcon.length; i++) {
				// �������������ʾ��Ժ����
				if (i == -1) {
					var desc = $g("��Ժ����");
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

			// ��ͼ���td��th���id
			$("#gridItemView tbody").find("tr").each(function (i) {
				$(this).children("td").each(function (j) {
					$(this).attr("id", "td_view_" + i + "_" + j);
				})
			});
		}

		//ͼ����롢λ�á�ͼ��·���Ķ��չ�ϵ
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

		//���ݺ�̨���ݸı��Ѿ���Ⱦ�����ʽ
		//var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv", "QryInfViewResult", PaadmID);
		var runQuery = $cm({
				ClassName:"DHCHAI.IRS.CCInfViewSrv",
				QueryName:"QryInfViewResult",
				aEpisodeID:PaadmID,
	        	rows:1000000
			},false);
		var DateIndex = obj.Viewtitle[0].DateIndex;
		if (!runQuery) {
			return;
		} else {
			obj.ViewResult = runQuery.rows;

			for (var i = 0; i < obj.ViewResult.length; i++) {
				var ItemCode = obj.ViewResult[i].IVItemCode;
				var ItemDate = obj.ViewResult[i].IVDate;
				var IVFlag = obj.ViewResult[i].IVFlag;
				var IVResult = obj.ViewResult[i].IVResult;
				var IVDateType = obj.ViewResult[i].IVDateType;
				var RID=""//����ID
				if(ItemCode=="HAI"){
				    //IVResult = obj.ViewResult[i].IVResult.split('^')[0].split("|")[0];
                    RID= obj.ViewResult[i].IVResult.split('^')[0].split("|")[1];
				}
				var KSS = "";
				var Result="",IsCure=""
				//�жϿ�������ߵȼ�
				if (ItemCode == "ANT") {
					if (IVResult.indexOf("KSS3") > -1) {
						KSS = "KSS3";
					} else if (IVResult.indexOf("KSS2") > -1) {
						KSS = "KSS2";
					} else {
						KSS = "KSS1";
					}				
					if (IVResult) {
						if (IVResult.indexOf("^") > -1) {
							var arryResult = IVResult.split('^');
							for (var k = 0; k < arryResult.length; k++) {
								if (arryResult[k] == "") continue;
								Result=Result + '\n' + arryResult[k].split("|")[0];
								if (IsCure!=1) {
									IsCure=arryResult[k].split("|")[2];
								}
							}
						}else {
							Result=IVResult.split("|")[0];
							IsCure=IVResult.split("|")[2];
						}
					}
				}

				var dayMaxTmp = 0; //�����������
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
							IVResult = IVResult + '\n' + arryIVResult[j].split("|")[0];
						}
						else{
							IVResult = IVResult + '\n' + arryIVResult[j];
						}
						
					}

					//��ȡ�������
					if (ItemCode == 'TMP') {
						var TempTmp = arryIVResult[j].split(' ')[0];
						TempTmp = TempTmp.replace(/[^\d.]/g, ''); //�����ֻ�С���滻Ϊ��
						TempTmp = parseFloat(TempTmp);

						if (dayMaxTmp < TempTmp) dayMaxTmp = TempTmp;
					}
				}
				if (IVFlag == 0) continue;
				//��ȡͼ��·�����кš��к�
				var evalstr = "var row = iconIndexMap." + ItemCode;
				eval(evalstr);
				var evalstr = "var src = iconSrcMap." + ItemCode;
				eval(evalstr);
				var column = ItemDate - DateIndex + 1;
				if (ItemCode == "HAI" && IVDateType == 3) {
					src = '../scripts/dhchai/img/Ժ�б���-ʵ.png';
				}

				if (ItemCode == "ANT")		//���������⴦��
				{
					var IVRows = obj.ViewResult[i].IVRows;	//�������к�Ϊ��̨���
					var eleID = 'td_view_' + (IVRows - 1) + '_' + column;
				} else {
					var eleID = 'td_view_' + (row - 1) + '_' + column;
				}

				/***************����������ʾ��ͬ��ͼ�� start*******************/
				var RepSrc = ''; //�������ڵ�src
				switch (ItemCode) {
					case 'RBT':
						RepSrc = '../scripts/dhchai/img/Ѫ����-��.png';
						break;
					case 'RUT':
						RepSrc = '../scripts/dhchai/img/�򳣹�-��.png';
						break;
					case 'ROT':
						RepSrc = '../scripts/dhchai/img/��������-��.png';
						break;
					case 'MDR':
						RepSrc = '../scripts/dhchai/img/������ҩ��-��.png';
						break;
					case 'BUG':
						RepSrc = '../scripts/dhchai/img/ϸ��-��.png';
						break;
				}
				/***************����������ʾ��ͬ��ͼ�� End*******************/


				//���ͼ��
				if (ItemCode == "ANT") {
					
					$("#" + eleID).attr("title", Result);
					//$("#" + eleID).attr("title", IVResult);
					//�����ر���
					if (KSS == "KSS1") {
						if (IsCure==1) {
							$("#" + eleID).attr('style',"background-color:"+obj.ViewBackColor[0][1]+";background-image:url('../scripts/DHCMA/HAI/img/triangle.png');background-position: right 0 top 0; background-repeat: no-repeat;");
						}else {
							$("#" + eleID).css("background-color", obj.ViewBackColor[0][1]);
						}
					} else if (KSS == "KSS2") {
						if (IsCure==1) {
							$("#" + eleID).attr('style',"background-color:"+obj.ViewBackColor[1][1]+";background-image:url('../scripts/DHCMA/HAI/img/triangle.png');background-position: right 0 top 0; background-repeat: no-repeat;");
						}else {
							$("#" + eleID).css("background-color", obj.ViewBackColor[1][1]);
						}
					} else {
						if (IsCure==1) {
							$("#" + eleID).attr('style',"background-color:"+obj.ViewBackColor[2][1]+";background-image:url('../scripts/DHCMA/HAI/img/triangle.png');background-position: right 0 top 0; background-repeat: no-repeat;");
						}else {
							$("#" + eleID).css("background-color", obj.ViewBackColor[2][1]);
						}
					}

				} else if (ItemCode == 'TMP') {
					var html = '<span id="tip" title="' + IVResult + '" style="color:red;">' + dayMaxTmp + '</span>';
					$("#" + eleID).append(html);
				}else if ((ItemCode == 'BUG')&&(IVDateType == 3)) {
					//�ͼ����Խ������
					//border-bottom: solid 3px #1a5cd3;
					$("#" + eleID).attr("title", IVResult);
					$("#" + eleID).css("border-bottom", "solid 3px #00B050");
					$("#" + eleID).css("height", "17px");
				} else {
					//HAI
					//�Ƿ��Ѿ����ͼ��
					if ($("#" + eleID).find('span').length) {
						//�滻ͼƬ
						$("#" + eleID + '>span>img').attr("src", src);
						//�޸���ʾ����
					    var oldTitle = $("#" + eleID + '>span').attr("title");
						var Title = oldTitle + '\n' + IVResult;
						//Title = IVResult;
						$("#" + eleID + '>span').attr("title", Title);
					} else { //��ǰû��ͼ��
						if (IVDateType == 2) {
							src = RepSrc;
						}
						var html = '<span id="tip" title="' + IVResult + '">' + '<img src = "' + src + '"></img>' + '</span>';
						if ((src!="")&&(src!=undefined)&&(src.indexOf('../scripts/dhchai/img/Ժ�б���')>-1 )) {
							var html = '<span id="tip" title="' + IVResult + '">' + '<img src = "' + src + '" id="'+RID+'"></img>' + '</span>';
						}
						$("#" + eleID).append(html);
					}
				}
			}
		}
		
		// ��ͼ���ʹ�ù��������
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

		// ��ͼ������Ĭ�Ϲ��������ұ�
		setTimeout(function () {
			if (obj.AdmDays > 30) {
				$("#gridItemView_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo", $("#gridItemView tr td:last"));
			}
		}, 100);
		
		// �״μ�����ϸ���ݣ���ͼʱ����������ϸ��
		obj.DateFrom = obj.Viewtitle[0].DateIndex;
		obj.DateTo = obj.Viewtitle[obj.Viewtitle.length - 1].DateIndex;
		refreshgridViewDetail();
		// ��ͼ��ͷ��ʾ
		for (var i = 0; i < obj.Viewtitle.length; i++) {
			if (obj.Viewtitle[i].TransLoc == "") continue;
			var innerHtml = $("#gridItemView_wrapper th")[i + 1].innerHTML;
			$("#gridItemView_wrapper th")[i + 1].innerHTML = '';
			var html = '<span id="tip" title="' + obj.Viewtitle[i].TransLoc + '">' + innerHtml + '</span>';
			$($("#gridItemView_wrapper th")[i + 1]).append(html);
		}
	}
	// ���¼�����ϸ�б�
	function refreshgridViewDetail() {
		/*
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
		*/	
		originalData["#gridViewDetail"]="";
        //$("#gridViewDetail").datagrid("loading"); //��������ʾ��Ϣ
        $cm({
            ClassName:"DHCHAI.IRS.CCInfViewSrv",
            QueryName:"QryInfViewDetail",
            aEpisodeID:PaadmID,
			aDateFrom:obj.DateFrom,
			aDateTo:obj.DateTo,
            page: 1,
            rows: 9999
        }, function (rs) {
            $('#gridViewDetail').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
	}
	obj.winOpenInfReport = function (ReportID) {
		if (!ReportID) return;
		var strUrl = "dhcma.hai.ir.inf.report.csp?1=1&ReportID=" + ReportID + "&AdminPower=1&2=2";
		//	var ratio = detectZoom();
		//var PageWidth = Math.round(1320 * ratio);
		//var page = websys_createWindow(strUrl, "", "width=" + PageWidth + ",height=95%");
		var page = websys_createWindow(strUrl, "", "width=80%,height=80%");
		//--�ر�ǰˢ�²�ѯ�б�
		var Loop = setInterval(function () {
			if (page.closed) {
				clearInterval(Loop);
				//ˢ���б�
				refreshGridView();
			}
		});

	}
	//��ȡ��ǰҳ�������ֵ
	function detectZoom() {
		var ratio = 1;
		if (BrowserVer == "isChrome") {   //ҽΪ�����Ϊ Chrome 49
			var userAgent = navigator.userAgent;
			var ChromePos = userAgent.indexOf("Chrome");  //Chrome��λ
			var ChromeStr = userAgent.substr(ChromePos);  //Chrome��
			var ChromeArr = ChromeStr.split(" ");
			var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome�汾
			if (ChromeVer <= 58) {
				ratio = window.devicePixelRatio;
			}
		}
		return ratio;
	}
	// ��ͼͼ�����¼�
	obj.gridItemView.on('click', 'td', function () {

		var colInd = obj.gridItemView.cell(this).index().column;
		var rowInd = obj.gridItemView.cell(this).index().row;		
		if (($("#td_view_" + rowInd + "_" + colInd + ":has(img)").length == 0) && (!$("#td_view_" + rowInd + "_" + colInd).attr("title"))) return;   //td�Ƿ���imgԪ�ػ�title��ʾ
	    //�����Ƭ��Ժ�У�����������ҳ��
		if (($("#td_view_" + rowInd + "_" + colInd + ":has(img)").length > 0) && ($("#td_view_" + rowInd + "_" + colInd).find("[class='mCS_img_loaded']").attr('src').indexOf("../scripts/dhchai/img/Ժ�б���") >-1)) {
		var RID=$("#td_view_" + rowInd + "_" + colInd).find("[class='mCS_img_loaded']").attr('id')
			obj.winOpenInfReport(RID);
		}
		var DateIndex = obj.Viewtitle[0].DateIndex;
		var ViewDate = parseInt(DateIndex) + parseInt(colInd) - 1;
		//������ϸ�б� 
		obj.DateFrom = ViewDate - 7;
		obj.DateTo = ViewDate + 7;
		refreshgridViewDetail();
	});

	// ��ͼͼ�����¼�
	$('#previous').on('click', function () {
		obj.CurrNo = obj.CurrNo + 1;
		refreshGridView();
	});
	// ��ͼͼ�����¼�
	$('#next').on('click', function () {
		if (obj.CurrNo == 1) {
			//alert('��һҳ�������ݣ�');
			//layer.alert('��һҳ�������ݣ�');
			//layer.msg('��һҳ�������ݣ�', { icon: 2 });
			$.messager.alert("ȷ��", $g("��һҳ�������ݣ�"), 'info');
			return;
		}
		obj.CurrNo = obj.CurrNo - 1;
		refreshGridView();
	});
}
