
/** 
 * 模块: 	 配液标签公共-创建html格式标签,append前台显示用
 * 编写日期: 2019-06-03
 * 编写人:   dinghongying
 */
 var PIVASLABEL = ({
    // labelData:打印标签条码数据
    Init: function(_options) {
        labelData = _options.labelData;
        var labelDataArr = labelData.split("|@|")
        var mainData = labelDataArr[0];
        var detailData = labelDataArr[1];
        var mainDataArr = mainData.split("^");
        var detailDataArr = detailData.split("||");
        var labelHtml = "";
        var headHtml = "";
        var bodyHtml = "";
        var footHtml = "";
        headHtml += '<div class="pivas-label-header">'
        // 抬头
        headHtml +=
            '<div style="height:25px">' +
            '<div style="float:center;width:200px;text-align:center;padding-left:90px;font-size:15px;">' +
            '静脉药物配置中心输液签' + 
            '</div>' +
            '<span style="float:right;padding-right:10px;font-size:12px;">' + mainDataArr[5] + '</span>' + // 打印序号
            '</div>';
        var batNoDesc=mainDataArr[6];
        if (mainDataArr[23]!=""){
	    	batNoDesc=batNoDesc+"("+mainDataArr[23]+")";
	    }
        headHtml +=
            '<div class="pivas-label-pat">' +
            '<span style="float:left;padding-left:10px;font-weight:bold;font-size:16px;">' + mainDataArr[3] + '</span>' + // 病区
            '<span style="float:right;font-weight:bold;font-size:16px;padding-right:10px;">' + batNoDesc+'-' + 
             mainDataArr[9]+ '</span>' + //  批次 是否打包 优先级
            '</div>';
        // 病人
        headHtml +=
            '<div class="pivas-label-pat">' +
            '<span style="float:left;padding-left:10px;">' + mainDataArr[25] + '</span>' + // 床号
            '<span>' + mainDataArr[26] + '</span>' + // 姓名
            '<span>' + mainDataArr[28] + '</span>' + // 年龄
            '<span>' + mainDataArr[29] + '</span>' + // 性别
            '<span style="float:right;padding-right:10px;">' + mainDataArr[30] + '</span>' + // 配液分类
            '</div>';
        // 医嘱信息
        headHtml +=
            '<div class=" pivas-label-ord">' +
            '<span style="float:left;padding-left:10px;">' + mainDataArr[11] + '</span>' + // 用法
            '<span>' + mainDataArr[27] + '</span>' + //登记号
            '</div>';
        headHtml +=
            '<div class=" pivas-label-ord">' +
            '<span style="float:left;padding-left:10px;">' + mainDataArr[4] + '</span>' + // 单号
            '<span>' + mainDataArr[31] + '</span>' + //条码
            '</div>';
        headHtml += '</div>';
        bodyHtml +=
            '<div class="pivas-label-body ">' +
            '<div style="border-bottom:1px solid black;height:20px ">' +
            '<div style="float:left;width:150px "> 药品</div>' +
            '<div style="float:left;width:60px; ">厂家</div>' +
            '<div style="float:left;width:60px; ">规格</div>' +
            '<div style="float:left;width:50px; ">剂量</div>' +
            '<div style="float:left;width:40px; ">数量</div>' +
            '</div>';
        var detailLen = detailDataArr.length;
        for (var i = 0; i < detailLen; i++) {
            var detailIArr = detailDataArr[i].split("^");
            var compStyle = ""; // 剂量是否整包装
            var moreStyle = "" // 溶媒超量
            if (detailIArr[5] == 1) {
                moreStyle = "font-weight:bold;"
            }
            if (detailIArr[3] != 1) {
                compStyle = "border-bottom:1px solid black;"
            }
            var oneRowHtml =
                '<div style="clear:both;' + moreStyle + compStyle + '">' +
                '<div style="float:left;width:250px">' + detailIArr[0]+ detailIArr[7]+detailIArr[2] + '</div>' + // 药品名称
                '<div style="float:left;width:70px;">' + detailIArr[1] + '</div>' + // 剂量
                '<div style="float:left;width:40px;">' + detailIArr[4] + '</div>' + // 数量
                '</div>';
            bodyHtml += oneRowHtml;
        }
        bodyHtml += '</div>'
        footHtml +=
            '<div class="pivas-label-footer ">' +
            '<div>' +
            '<span style="font-weight:bold;">' + '用药:' + '</span>' + 
            '<span style="font-weight:bold;">' + mainDataArr[12] + '</span>' + // 用药时间
            '<span style="font-weight:bold;margin-left:10px;">' + mainDataArr[10] + '</span>' + // 频次
            '<span style="font-weight:bold;margin-left:10px;">' + mainDataArr[35] + '</span>' + // 滴速
            '</div>' +
            '<div style="border-bottom:1px solid black;height:20px">' +
            '<div >' + '说明:' + mainDataArr[33]+' '+mainDataArr[34]+'</div>' +
            '</div>' +
            '<div>' +
            '<div style="width:120px;float:left ">' + '打签:' + mainDataArr[42] + '</div>' +
            '<div style="width:120px;float:left ">' + '排药:' + mainDataArr[37] + '</div>' +
            '<div style="width:120px;float:left ">' + '审核:' + mainDataArr[19] + '</div>' +
            '</div>' +
            '<div style="border-bottom:1px solid black;height:20px">' +
            '<div style="width:120px;float:left ">' + '配液:' + '</div>' +
            '<div style="width:120px;float:left ">' + '复核:' + '</div>' +
            '<div style="width:120px;float:left ">' + '医师:' + mainDataArr[22] + '</div>' +
            '</div>';
        labelHtml = headHtml + bodyHtml + footHtml;
        $("#labelContent").html(labelHtml);
    }

})