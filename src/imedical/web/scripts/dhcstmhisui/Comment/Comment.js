var init = function() {
	var EpisodeId = '';
	var IncCode = '';
	var PaadmType = '';
	/* 按钮事件*/
	/* --查询--*/
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			ComSearch(Select);
		}
	});
	var Select = function(ComRowid, RetStatus) {
		ComMainGrid.load({
			ClassName: 'web.DHCSTMHUI.Comment',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			Parref: ComRowid,
			RetStatus: RetStatus
		});
	};
	
	var ComMainCm = [[
		{
			title: '点评明细id',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100,
			hidden: true
		}, {
			title: '高值医嘱提取表id',
			field: 'ORIRowId',
			width: 100,
			hidden: true
		}, {
			title: '医嘱ID',
			field: 'Oeori',
			hidden: true,
			width: 80
		}, {
			title: '点评单号',
			field: 'ComNo',
			width: 200,
			hidden: true
		}, {
			title: '医嘱名称',
			field: 'Arcim',
			width: 180
		}, {
			title: '高值条码',
			field: 'Barcode',
			width: 120
		}, {
			title: '点评结果',
			field: 'CurRet',
			width: 80,
			formatter: function(value, row, index) {
				if (row.CurRet == 0) {
					return '不合理';
				} else if (row.CurRet == 1) {
					return '合理';
				} else if (row.CurRet == 2) {
					return '已申诉';
				} else if (row.CurRet == 3) {
					return '已接受';
				} else if (row.CurRet == 4) {
					return '未点评';
				} else {
					return '';
				}
			}
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '数量',
			field: 'OeoriNum',
			width: 40
		}, {
			title: '单位',
			field: 'OeoriUom',
			width: 50
		}, {
			title: '开单科室',
			field: 'OeoriLoc',
			width: 150
		}, {
			title: '开单医生',
			field: 'OeoriDoctor',
			width: 100
		}, {
			title: '医嘱日期',
			field: 'OeoriDate',
			width: 100
		}, {
			title: '医嘱时间',
			field: 'OeoriTime',
			width: 100
		}, {
			title: '接收科室',
			field: 'OeoriRecLoc',
			width: 150
		}, {
			title: 'Adm',
			field: 'Adm',
			width: 100,
			hidden: true
		}
	]];
	var ComMainGrid = $UI.datagrid('#ComMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Comment',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		onClickRow: function(index, row) {
			ComMainGrid.commonClickRow(index, row);
		},
		columns: ComMainCm,
		toolbar: '#ComMainTB',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		},
		onSelect: function(index, row) {
			// 患者基本信息
			$('#Patinfo').empty();
			EpisodeId = row.Adm;
			IncCode = row.InciCode;
			var ArrData = $.cm({
				ClassName: 'web.DHCSTMHUI.Comment',
				MethodName: 'GetPaInfo',
				adm: EpisodeId
			}, false);
			var patordinfo = '';
			var patId = ArrData.papmidr;
			var patNo = ArrData.patNo;
			var patName = ArrData.patName;
			PaadmType = ArrData.paadmtype;
			var imageid = '';
			var sexDesc = ArrData.sexDesc;	// 性别
			if (sexDesc == '女') {
				imageid = 'icon-female.png';
			} else if (sexDesc == '男') {
				imageid = 'icon-male.png';
			} else {
				imageid = 'icon-unmale.png';
			}
			var patAge = ArrData.patAge;
			
			var depdesc = ArrData.depdesc;
			var patDiag = '诊断：' + ArrData.diag;	// 诊断
			patordinfo = patordinfo + '<span>' + patNo + '&nbsp;&nbsp;</span>|&nbsp;&nbsp;';
			patordinfo = patordinfo + '<span>' + sexDesc + '&nbsp;&nbsp;</span>|&nbsp;&nbsp;';
			patordinfo = patordinfo + '<span>' + patAge + '&nbsp;&nbsp;</span>|&nbsp;&nbsp;';
			patordinfo = patordinfo + '<span>' + depdesc + '&nbsp;&nbsp;</span>|&nbsp;&nbsp;';
			var pathtml = ' <div class="col-md-12" id="patInfo"><div style="margin-left:10px;">'
				+ '<a href="#" class="thumbnail" style="border:0px;height:20px;">'
				+ '<img src=../scripts/dhcstmhisui/Common/images/' + imageid + ' style="border-radius:35px;height:50px;width:50px;">'
				+ '</a>'
                + '</div>'
				+ ' <div style="margin-left:70px;margin-top:-40px;">'
				+ ' <span style="font-size:17px;">' + patName + '&nbsp;&nbsp;&nbsp;</span>'
				+ patordinfo
				+ ' </div></div>';
			var pathtml = pathtml + '<div style="margin-top:10px;margin-left:60px;">' + ' <span>&nbsp;&nbsp;&nbsp;' + patDiag + '</span>' + ' </div>';
			$('#Patinfo').append(pathtml);
			if ((patordinfo != '') && (patordinfo != undefined)) {
				if ($('#PatPanel').hasClass('NoDataPic')) {
					$('#PatPanel').removeClass('NoDataPic');
				} else if ($('#PatPanel').hasClass('LiteNoDataPic')) {
					$('#PatPanel').removeClass('LiteNoDataPic');
				}
			}
			var tab = $('#tabsForm').tabs('getSelected');
			var index = $('#tabsForm').tabs('getTabIndex', tab);
			var url = '';
			if (index == 0) {	// 过敏记录
				url = 'dhcem.allergyenter.csp' + '?EpisodeID=' + EpisodeId + '&PatientID=' + patId;
				$('#ifrmAllergy').attr('src', CommonFillUrl(url));
			} else if (index == 1) {	// 检查记录
				url = 'dhcapp.inspectrs.csp' + '?EpisodeID=' + EpisodeId + '&PatientID=' + patId;
				$('#ifrmRisQuery').attr('src', CommonFillUrl(url));
			} else if (index == 2) {	// 检验记录
				url = 'dhcapp.seepatlis.csp' + '?EpisodeID=' + EpisodeId + '&NoReaded=' + '1' + '&PatientID=' + patId;
				$('#ifrmLisQuery').attr('src', CommonFillUrl(url));
			} else if (index == 3) {	// 病历浏览
				url = 'emr.bs.browse.csp' + '?EpisodeID=' + EpisodeId;
				$('#ifrmEMR').attr('src', CommonFillUrl(url));
			} else if (index == 4) {	// 本次医嘱
				if (PaadmType == 'I') {
					url = 'ipdoc.patorderview.csp' + '?EpisodeID=' + EpisodeId + '&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL';
					$('#ifrmOrdQuery').attr('src', CommonFillUrl(url));
				} else {
					url = 'oeorder.opbillinfo.csp' + '?PatientID=' + patId + '&EpisodeID=' + EpisodeId + '&mradm=' + EpisodeId + '&OpenWinName=OPDocRecAdm';
					$('#ifrmOrdQuery').attr('src', CommonFillUrl(url));
				}
			} else if (index == 5) {	// 会诊记录
				url = 'dhcem.consultpathis.csp' + '?EpisodeID=' + EpisodeId + '&PatientID=' + patId;
				$('#ifrmConQuery').attr('src', CommonFillUrl(url));
			} else if (index == 6) {	// 说明书
				url = 'ddhc.bdp.kb.dhcmatbrowser.csp' + '?GenCode=' + InciCode;
				$('#ifrmInstruction').attr('src', CommonFillUrl(url));
			}
		}
	});
	$HUI.tabs('#tabsForm', {
		onSelect: function(title, index) {
			var Row = ComMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请先选择一条高值医嘱!');
				return;
			}
			
			var ArrData = tkMakeServerCall('web.DHCSTMHUI.Comment', 'GetPaInfo', EpisodeId);
			var patId = ArrData.papmidr;
			// 将患者信息传至头菜单，避免引用界面串患者
			var menuWin = websys_getMenuWin(); // 获得头菜单Window对象
			if (menuWin) {
				var frm = dhcsys_getmenuform(); // menuWin.document.forms['fEPRMENU'];
				if ((frm) && (frm.EpisodeID.value != EpisodeId)) {
					// if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails();  //清除头菜单上所有病人相关信息
					frm.EpisodeID.value = EpisodeId;
					frm.PatientID.value = patId;
				}
			}
			var url = '';
			if (title == '病历浏览') {
				if ($('#ifrmEMR').attr('src') == '' || 'undefined') {
					url = 'emr.bs.browse.csp' + '?EpisodeID=' + EpisodeId;
					$('#ifrmEMR').attr('src', CommonFillUrl(url));
				}
			} else if (title == '过敏记录') {
				if ($('#ifrmAllergy').attr('src') == '' || 'undefined') {
					url = 'dhcem.allergyenter.csp' + '?EpisodeID=' + EpisodeId + '&PatientID=' + patId;
					$('#ifrmAllergy').attr('src', CommonFillUrl(url));
				}
			} else if (title == '检查记录') {
				if ($('#ifrmRisQuery').attr('src') == '' || 'undefined') {
					url = 'dhcapp.inspectrs.csp' + '?EpisodeID=' + EpisodeId + '&PatientID=' + patId;
					$('#ifrmRisQuery').attr('src', CommonFillUrl(url));
				}
			} else if (title == '检验记录') {
				if ($('#ifrmLisQuery').attr('src') == '' || 'undefined') {
					url = 'dhcapp.seepatlis.csp' + '?EpisodeID=' + EpisodeId + '&NoReaded=' + '1' + '&PatientID=' + patId;
					$('#ifrmLisQuery').attr('src', CommonFillUrl(url));
				}
			} else if (title == '本次医嘱') {
				if ($('#ifrmOrdQuery').attr('src') == '' || 'undefined') {
					if (PaadmType == 'I') {
						url = 'ipdoc.patorderview.csp' + '?EpisodeID=' + EpisodeId + '&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL';
						$('#ifrmOrdQuery').attr('src', CommonFillUrl(url));
					} else {
						url = 'oeorder.opbillinfo.csp' + '?PatientID=' + patId + '&EpisodeID=' + EpisodeId + '&mradm=' + EpisodeId + '&OpenWinName=OPDocRecAdm';
						$('#ifrmOrdQuery').attr('src', CommonFillUrl(url));
					}
				}
			} else if (title == '会诊记录') {
				if ($('#ifrmConQuery').attr('src') == '' || 'undefined') {
					url = 'dhcem.consultpathis.csp' + '?EpisodeID=' + EpisodeId + '&PatientID=' + patId;
					$('#ifrmConQuery').attr('src', CommonFillUrl(url));
				}
			} else if (title == '说明书') {
				if ($('#ifrmInstruction').attr('src') == '' || 'undefined') {
					url = 'ddhc.bdp.kb.dhcmatbrowser.csp' + '?GenCode=' + IncCode;
					$('#ifrmInstruction').attr('src', CommonFillUrl(url));
				}
			}
		}
	});
	/* --点评合理--*/
	$UI.linkbutton('#PassBT', {
		onClick: function() {
			var Row = ComMainGrid.getSelected();
			if ((isEmpty(Row)) || (Row.length == 0)) {
				$UI.msg('alert', '请选择需要点评的医嘱明细!');
				return false;
			}
			var DetailId = Row.RowId;
			var Params = JSON.stringify(addSessionParams({
				Result: 'Y'
			}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.Comment',
				MethodName: 'SaveLogItm',
				DetailId: DetailId,
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var ComRowid = jsonData.rowid;
					Select(ComRowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	/* --点评不合理--*/
	$UI.linkbutton('#RefuseBT', {
		onClick: function() {
			var Row = ComMainGrid.getSelected();
			if ((isEmpty(Row)) || (Row.length == 0)) {
				$UI.msg('alert', '请选择需要点评的医嘱明细!');
				return false;
			}
			var DetailId = Row.RowId;
			ComRefuse(DetailId, Select);
		}
	});
	/* --点评日志--*/
	$UI.linkbutton('#LogBT', {
		onClick: function() {
			var Row = ComMainGrid.getSelected();
			if ((isEmpty(Row)) || (Row.length == 0)) {
				$UI.msg('alert', '请选择医嘱明细!');
				return false;
			}
			var DetailId = Row.RowId;
			ComLogSearch(DetailId);
		}
	});
	function Default() {
		var emptyMsg = '请先选择一条医嘱';
		var pathtml = ' <div class="col-md-12" id="patInfo"><div align="center" style="padding-top:180px; padding-left:310px" >'
			+ ' <span style="font-size:14px;color:#666666">' + emptyMsg
			+ ' </div></div>';
		$('#Patinfo').append(pathtml);
		if (HISUIStyleCode == 'lite') {
			$('#PatPanel').removeClass('NoDataPic');
			$('#PatPanel').addClass('LiteNoDataPic');
		}
		var url = 'dhcem.allergyenter.csp' + '?EpisodeID=' + '' + '&PatientID=' + '';
		$('#ifrmAllergy').attr('src', CommonFillUrl(url));
	}
	Default();
	$('#SearchBT').click();
};
$(init);