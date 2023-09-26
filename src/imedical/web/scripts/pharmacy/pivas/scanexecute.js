/** 
 * 模块: 	 配液状态执行-扫描
 * 编写日期: 2018-03-16
 * 编写人:   yunhaibao
 */
var PIVASSCAN = ({
    // 扫描执行
    Execute: function (barCode, psNumber, locId, pogsNo, qParams) {

        // 扫前验证数据
        var chkRet = tkMakeServerCall("web.DHCSTPIVAS.ScanExecute", "CheckScanData", barCode, qParams);
        var chkRetArr = chkRet.toString().split("^");
        if (chkRetArr[0] < 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: chkRetArr[1],
                type: 'alert'
            });
            PIVAS.Media.Play("warning");
            $("#labelContent").html("");
            return;
        }
        // 每次扫描只调一次数据库
        $.m({
            ClassName: "web.DHCSTPIVAS.ScanExecute",
            MethodName: "SaveData",
            barCode: barCode,
            userId: SessionUser,
            psNumber: psNumber,
            locId: locId,
            pogsNo: pogsNo
        }, function (retData) {
            var retArr = retData.split("|$|");
            if (retArr[0] < 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: retArr[1],
                    type: 'error'
                });
                PIVAS.Media.Play("warning");
                $("#labelContent").html("");
                return;
            }
            var labelData = retArr[1];
            var wardId = retArr[2];
            PIVASSCAN.AppendLabel(labelData); // 此处异步不冲突
            PIVASSCAN.CalcuWard(wardId);
            PIVAS.Media.Play("success");
        });
    },
    // 扫后与界面匹配是否前台计算,否则取后台数据
    CalcuWard: function (wardId) {
        // 判断界面是否存在该病区已扫未扫的数据合计
        var $scanWard = "#scan-wardId-" + wardId;
        if ($($scanWard).text() == "") {
            var params = QueryParams("CalcuWard");
            $.cm({
                ClassName: "web.DHCSTPIVAS.ScanExecute",
                MethodName: "JsGetScanWardData",
                inputStr: params,
                wardId: wardId
            }, function (retJson) {
                //console.log(retJson)
                if (retJson.length > 0) {
                    PIVASSCAN.AppendWard(retJson);
                    if (wardId != "") {
                        // 加载完界面
                        // 总数-合计+1
                        PIVASSCAN.Calculate("#scan-total", 1);
                        // 总数-未扫-0
                        // 总数-已扫+1
                        PIVASSCAN.Calculate("#scaned-total", 1);
                        // 病区-合计+1
                        PIVASSCAN.Calculate("#scan-wardId-" + wardId + " #scan-wardTotal", 1);
                        // 病区-未扫-0
                        // 病区+已扫+1
                        PIVASSCAN.Calculate("#scan-wardId-" + wardId + " #scaned-wardTotal", 1);
                        PIVASSCAN.FocusWard(wardId);
                    }
                }
            })
        } else {
            // 病区-合计+0
            // 病区-未扫-1
            PIVASSCAN.Calculate("#scan-wardId-" + wardId + " #unscan-wardTotal", -1);
            // 病区-已扫+1
            PIVASSCAN.Calculate("#scan-wardId-" + wardId + " #scaned-wardTotal", 1);
            // 总数-合计+0
            // 总数-未扫-1
            PIVASSCAN.Calculate("#unscan-total", -1);
            // 总数+已扫+1
            PIVASSCAN.Calculate("#scaned-total", 1);
            PIVASSCAN.FocusWard(wardId)
        }
    },
    // 计算组数,_id:id,_num(正负数)
    Calculate: function (_id, _num) {
        if ((_num == "") || (_id == "") || (_num == 0)) {
            return
        }
        _num = parseInt(_num);
        var origVal = $(_id).text().trim();
        if (origVal != "") {
            $(_id).text(parseInt(origVal) + _num)
        }
    },
    // 填充标签信息
    AppendLabel: function (labelData) {
        if (labelData == "") {
            DHCPHA_HUI_COM.Msg.popover({
                msg: "执行成功,获取标签数据失败",
                type: 'error'
            });
            $("#labelContent").html("");
            return;
        }
        PIVASLABEL.Init({
            labelData: labelData
        })
    },
    // 填充病区信息
    AppendWard: function (jsonData) {
        for (var i = 0; i < jsonData.length; i++) {
            var jsonIData = jsonData[i];
            var wardHtml = this.MakeWardHtml(jsonIData);
            if (wardHtml != "") {
                $("#scan-ward").append(wardHtml)
            }
            var total = jsonIData.total;
            // 合计总数
            this.Calculate("#scan-total", total);
            // 未扫总数
            this.Calculate("#unscan-total", total);
        }
        $("div[id*='scan-wardId-']").mouseenter(function () {
            $(this).css({
                "border-color": "#D9534F"
            })
        })
        $("div[id*='scan-wardId-']").mouseleave(function () {
            $(this).css({
                "border-color": "#509DE1"
            })
        })
    },
    MakeWardHtml: function (data) {
        var _html =
            '<div id="scan-wardId-' + data.wardId + '" style="float:left;width:165px;border:2px solid #509DE1;margin:7px;border-radius:3px;">' +
            '<div id="scan-wardDesc" style="border-bottom:2px solid #509DE1;font-weight:bold;font-size:15px;height:25px;line-height:25px;padding-left:5px">' +
            data.wardDesc +
            '</div>' +
            '<div style="text-align:center;height:25px;line-height:25px;border-bottom:2px solid #5BC0DE;">' +
            '  <div style="float:left;width:40%;background:#5BC0DE;color:white">' +
            '      合计组数' +
            '  </div>' +
            '  <div id="scan-wardTotal" style="float:left;width:60%;text-align:center;color:#5BC0DE;font-weight:bold">' +
            data.total +
            '   </div>' +
            '</div>' +
            '<div style="text-align:center;height:25px;line-height:25px;border-bottom:2px solid #D9534F;">' +
            '	<div style="float:left;width:40%;background:#D9534F;color:white;">' +
            '		未扫组数' +
            '	</div>' +
            '	<div id="unscan-wardTotal" style="float:left;width:60%;text-align:center;color:#D9534F;font-weight:bold">' +
            data.total +
            ' 	</div>' +
            '</div>' +
            '<div style="text-align:center;height:25px;line-height:25px;border-bottom:1px solid #5CB85C;">' +
            '	<div style="float:left;width:40%;background:#5CB85C;color:white">' +
            '		已扫组数' +
            '	</div>' +
            '	<div id="scaned-wardTotal" style="float:left;width:60%;text-align:center;color:#5CB85C;font-weight:bold">' +
            0 +
            '	</div>' +
            '</div>' +
            '</div>'
        return _html;

    },
    // 变背景色
    FocusWard: function (wardId) {
        var $wardId = "#scan-wardId-" + wardId
        if ($($wardId).text().trim() != "") {
            $("div[id*='scan-wardId-']").css({
                background: "white"
            });
            $($wardId).css({
                background: "#eff7ff"
            })
        }
    },
    Clean: function () {
        $("#txtBarCode").val("");
        $("#txtGeneNo").val("");
        $("#scan-ward").html("");
        $("#labelContent").html("");
        $("#scan-total").text(0);
        $("#scaned-total").text(0);
        $("#unscan-total").text(0);
        $("#txtBarCode").focus();
    }

})