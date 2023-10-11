/**
 * @Description: 移动药房 - 打印公共方法
 * @Creator:     Huxt 2021-03-05
 * @Js:          pha/mob/v2/print.js
 */

var PHA_MOB_PRINT = {
    /**
     * @creator: Huxt 2020-12-08
     * @description: 打印处方 (西药&中药)
     * PHA_MOB_PRINT.PrintPresc();
     */
    PrintPresc: function(prescNo){
        var jsonData = $.cm({
            ClassName: 'PHA.MOB.COM.Print',
            MethodName: 'PrescPrintData',
            prescNo: prescNo
        }, false);
        if (jsonData.errCode < 0 || jsonData.success == 0) {
            return;
        }
        if (!jsonData.Templet) {
            return;
        }
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: jsonData.Templet,
            data: jsonData,
            extendFn: function(data){
                return {
                    PrtDevice: data.Para.PrtDevice
                }
            }
        });
    },
    
    /**
     * @creator: Huxt 2020-12-08
     * @description: 打印配药单 (西药&中药)
     * PHA_MOB_PRINT.PrintPyd();
     */
    PrintPyd: function(prescNo) {
        var jsonData = $.cm({
            ClassName: 'PHA.MOB.COM.Print',
            MethodName: 'PydPrintData',
            prescNo: prescNo
        }, false);
        if (jsonData.errCode < 0 || jsonData.success == 0) {
            return;
        }
        if (!jsonData.Templet) {
            return;
        }
        
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: jsonData.Templet,
            data: jsonData,
            extendFn: function(data){
                return {
                    PrtDevice: data.Para.PrtDevice
                }
            }
        });
    },

    /**
     * @creator: Huxt 2020-12-08
     * @description: 打印用法标签 (门诊西药)
     * PHA_MOB_PRINT.PrintLabel();
     */
    PrintLabel: function(prescNo) {
        OUTPHA_PRINTCOM.Label(prescNo, "1");
    },

    /**
     * @creator: Huxt 2020-12-08
     * @description: 打印贵重要品标签 (仅中药)
     * PHA_MOB_PRINT.PrintPriceLabel();
     */
    PrintPriceLabel: function(prescNo) {
        var jsonData = $.cm({
            ClassName: 'PHA.MOB.COM.Print',
            MethodName: 'PriceLabelPrintData',
            prescNo: prescNo
        }, false);
        if (jsonData.errCode < 0 || jsonData.success == 0) {
            return;
        }
        
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: "PHAINPriceLabel",
            data: jsonData,
            page: {
                rows: 1,
                format: ""
            },
            extendFn: function(data){
                return {
                    PrtDevice: data.Para.PrtDevice
                }
            }
        });
    },

    /**
     * @creator: Huxt 2020-12-08
     * @description: 物流箱汇总标签 (中药物流标签-封箱贴)
     * PHA_MOB_PRINT.PrintBoxLable();
     */
    PrintBoxLable: function(boxId, rePrintFlag){
        var boxArr= [boxId]
        rePrintFlag = rePrintFlag || '';
        var boxArrStr = boxArr;
        if (typeof boxArrStr === 'object'){
             boxArrStr = JSON.stringify(boxArrStr);
        }
        var prtData = tkMakeServerCall('PHA.IP.Print.Box', 'GetJsonData', boxArrStr);
        var prtArr = JSON.parse(prtData);
        for (var i = 0; i < prtArr.length; i++) {
            var prtJson = prtArr[i];
            var newPrtJson = {
                Para:prtJson,
                List:[]
            }
            newPrtJson.Para.toLoc = newPrtJson.Para.toLoc + (rePrintFlag !== '' ? '(补)' : '')
             PRINTCOM.XML({
                 printBy: 'lodop', // inv or lodop, default is lodop
                 XMLTemplate: 'PHAIPBOX',
                 data: newPrtJson,
                 preview: false
             });
             
//            var xmlPrtObj = DHCSTXMLPrint_JsonToXml(newPrtJson);
//            DHCSTGetXMLConfig('PHAIPBOX');          
//            DHCSTPrintFun(xmlPrtObj.xmlPara, xmlPrtObj.xmlList);
        }
        return
        var jsonData = $.cm({
            ClassName: 'PHA.MOB.COM.Print',
            MethodName: 'BoxPrintData',
            boxId: boxId
        }, false);
        if (jsonData.errCode < 0 || jsonData.success == 0) {
            return;
        }
        
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: "PHAINBoxLabel",
            data: jsonData,
            extendFn: function(data){
                return {
                    PrtDevice: data.Para.PrtDevice
                }
            }
        });
    },

    /**
     * @creator: Huxt 2021-03-12
     * @description: 中草药代煎标签
     * PHA_MOB_PRINT.PrintDJLabel();
     */
    PrintDJLabel: function(prescNo, printNum){
        var prescDataStr = tkMakeServerCall('PHA.MOB.COM.Print', 'GetDJLabelData', prescNo);
        if (prescDataStr == "" || prescDataStr == "{}") {
            return;
        }
        var prescData = eval('(' + prescDataStr + ')');
        
        var newPrintNum = prescData.printNum;
        if (printNum && printNum > 0) {
            newPrintNum = printNum
        }
        
        for (var i = 0; i < newPrintNum; i++) {
            PRINTCOM.XML({
                printBy: 'lodop',
                XMLTemplate: "PHAINDJLabel",
                data: {
                    Para: prescData,
                    List: []
                },
                extendFn: function(data){
                    return {
                        PrtDevice: ''
                    }
                }
            });
        }
        
    }
    
    
}





