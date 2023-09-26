/** 
 * ģ��: 	 ��Һ״ִ̬��-ɨ��
 * ��д����: 2018-03-16
 * ��д��:   yunhaibao
 */
var PIVASSCAN = ({
    // ɨ��ִ��
    Execute: function (barCode, psNumber, locId, pogsNo, qParams) {

        // ɨǰ��֤����
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
        // ÿ��ɨ��ֻ��һ�����ݿ�
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
            PIVASSCAN.AppendLabel(labelData); // �˴��첽����ͻ
            PIVASSCAN.CalcuWard(wardId);
            PIVAS.Media.Play("success");
        });
    },
    // ɨ�������ƥ���Ƿ�ǰ̨����,����ȡ��̨����
    CalcuWard: function (wardId) {
        // �жϽ����Ƿ���ڸò�����ɨδɨ�����ݺϼ�
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
                        // ���������
                        // ����-�ϼ�+1
                        PIVASSCAN.Calculate("#scan-total", 1);
                        // ����-δɨ-0
                        // ����-��ɨ+1
                        PIVASSCAN.Calculate("#scaned-total", 1);
                        // ����-�ϼ�+1
                        PIVASSCAN.Calculate("#scan-wardId-" + wardId + " #scan-wardTotal", 1);
                        // ����-δɨ-0
                        // ����+��ɨ+1
                        PIVASSCAN.Calculate("#scan-wardId-" + wardId + " #scaned-wardTotal", 1);
                        PIVASSCAN.FocusWard(wardId);
                    }
                }
            })
        } else {
            // ����-�ϼ�+0
            // ����-δɨ-1
            PIVASSCAN.Calculate("#scan-wardId-" + wardId + " #unscan-wardTotal", -1);
            // ����-��ɨ+1
            PIVASSCAN.Calculate("#scan-wardId-" + wardId + " #scaned-wardTotal", 1);
            // ����-�ϼ�+0
            // ����-δɨ-1
            PIVASSCAN.Calculate("#unscan-total", -1);
            // ����+��ɨ+1
            PIVASSCAN.Calculate("#scaned-total", 1);
            PIVASSCAN.FocusWard(wardId)
        }
    },
    // ��������,_id:id,_num(������)
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
    // ����ǩ��Ϣ
    AppendLabel: function (labelData) {
        if (labelData == "") {
            DHCPHA_HUI_COM.Msg.popover({
                msg: "ִ�гɹ�,��ȡ��ǩ����ʧ��",
                type: 'error'
            });
            $("#labelContent").html("");
            return;
        }
        PIVASLABEL.Init({
            labelData: labelData
        })
    },
    // ��䲡����Ϣ
    AppendWard: function (jsonData) {
        for (var i = 0; i < jsonData.length; i++) {
            var jsonIData = jsonData[i];
            var wardHtml = this.MakeWardHtml(jsonIData);
            if (wardHtml != "") {
                $("#scan-ward").append(wardHtml)
            }
            var total = jsonIData.total;
            // �ϼ�����
            this.Calculate("#scan-total", total);
            // δɨ����
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
            '      �ϼ�����' +
            '  </div>' +
            '  <div id="scan-wardTotal" style="float:left;width:60%;text-align:center;color:#5BC0DE;font-weight:bold">' +
            data.total +
            '   </div>' +
            '</div>' +
            '<div style="text-align:center;height:25px;line-height:25px;border-bottom:2px solid #D9534F;">' +
            '	<div style="float:left;width:40%;background:#D9534F;color:white;">' +
            '		δɨ����' +
            '	</div>' +
            '	<div id="unscan-wardTotal" style="float:left;width:60%;text-align:center;color:#D9534F;font-weight:bold">' +
            data.total +
            ' 	</div>' +
            '</div>' +
            '<div style="text-align:center;height:25px;line-height:25px;border-bottom:1px solid #5CB85C;">' +
            '	<div style="float:left;width:40%;background:#5CB85C;color:white">' +
            '		��ɨ����' +
            '	</div>' +
            '	<div id="scaned-wardTotal" style="float:left;width:60%;text-align:center;color:#5CB85C;font-weight:bold">' +
            0 +
            '	</div>' +
            '</div>' +
            '</div>'
        return _html;

    },
    // �䱳��ɫ
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