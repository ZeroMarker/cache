
/** 
 * ģ��: 	 ��Һ��ǩ����-����html��ʽ��ǩ,appendǰ̨��ʾ��
 * ��д����: 2019-06-03
 * ��д��:   dinghongying
 */
 var PIVASLABEL = ({
    // labelData:��ӡ��ǩ��������
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
        // ̧ͷ
        headHtml +=
            '<div style="height:25px">' +
            '<div style="float:center;width:200px;text-align:center;padding-left:90px;font-size:15px;">' +
            '����ҩ������������Һǩ' + 
            '</div>' +
            '<span style="float:right;padding-right:10px;font-size:12px;">' + mainDataArr[5] + '</span>' + // ��ӡ���
            '</div>';
        var batNoDesc=mainDataArr[6];
        if (mainDataArr[23]!=""){
	    	batNoDesc=batNoDesc+"("+mainDataArr[23]+")";
	    }
        headHtml +=
            '<div class="pivas-label-pat">' +
            '<span style="float:left;padding-left:10px;font-weight:bold;font-size:16px;">' + mainDataArr[3] + '</span>' + // ����
            '<span style="float:right;font-weight:bold;font-size:16px;padding-right:10px;">' + batNoDesc+'-' + 
             mainDataArr[9]+ '</span>' + //  ���� �Ƿ��� ���ȼ�
            '</div>';
        // ����
        headHtml +=
            '<div class="pivas-label-pat">' +
            '<span style="float:left;padding-left:10px;">' + mainDataArr[25] + '</span>' + // ����
            '<span>' + mainDataArr[26] + '</span>' + // ����
            '<span>' + mainDataArr[28] + '</span>' + // ����
            '<span>' + mainDataArr[29] + '</span>' + // �Ա�
            '<span style="float:right;padding-right:10px;">' + mainDataArr[30] + '</span>' + // ��Һ����
            '</div>';
        // ҽ����Ϣ
        headHtml +=
            '<div class=" pivas-label-ord">' +
            '<span style="float:left;padding-left:10px;">' + mainDataArr[11] + '</span>' + // �÷�
            '<span>' + mainDataArr[27] + '</span>' + //�ǼǺ�
            '</div>';
        headHtml +=
            '<div class=" pivas-label-ord">' +
            '<span style="float:left;padding-left:10px;">' + mainDataArr[4] + '</span>' + // ����
            '<span>' + mainDataArr[31] + '</span>' + //����
            '</div>';
        headHtml += '</div>';
        bodyHtml +=
            '<div class="pivas-label-body ">' +
            '<div style="border-bottom:1px solid black;height:20px ">' +
            '<div style="float:left;width:150px "> ҩƷ</div>' +
            '<div style="float:left;width:60px; ">����</div>' +
            '<div style="float:left;width:60px; ">���</div>' +
            '<div style="float:left;width:50px; ">����</div>' +
            '<div style="float:left;width:40px; ">����</div>' +
            '</div>';
        var detailLen = detailDataArr.length;
        for (var i = 0; i < detailLen; i++) {
            var detailIArr = detailDataArr[i].split("^");
            var compStyle = ""; // �����Ƿ�����װ
            var moreStyle = "" // ��ý����
            if (detailIArr[5] == 1) {
                moreStyle = "font-weight:bold;"
            }
            if (detailIArr[3] != 1) {
                compStyle = "border-bottom:1px solid black;"
            }
            var oneRowHtml =
                '<div style="clear:both;' + moreStyle + compStyle + '">' +
                '<div style="float:left;width:250px">' + detailIArr[0]+ detailIArr[7]+detailIArr[2] + '</div>' + // ҩƷ����
                '<div style="float:left;width:70px;">' + detailIArr[1] + '</div>' + // ����
                '<div style="float:left;width:40px;">' + detailIArr[4] + '</div>' + // ����
                '</div>';
            bodyHtml += oneRowHtml;
        }
        bodyHtml += '</div>'
        footHtml +=
            '<div class="pivas-label-footer ">' +
            '<div>' +
            '<span style="font-weight:bold;">' + '��ҩ:' + '</span>' + 
            '<span style="font-weight:bold;">' + mainDataArr[12] + '</span>' + // ��ҩʱ��
            '<span style="font-weight:bold;margin-left:10px;">' + mainDataArr[10] + '</span>' + // Ƶ��
            '<span style="font-weight:bold;margin-left:10px;">' + mainDataArr[35] + '</span>' + // ����
            '</div>' +
            '<div style="border-bottom:1px solid black;height:20px">' +
            '<div >' + '˵��:' + mainDataArr[33]+' '+mainDataArr[34]+'</div>' +
            '</div>' +
            '<div>' +
            '<div style="width:120px;float:left ">' + '��ǩ:' + mainDataArr[42] + '</div>' +
            '<div style="width:120px;float:left ">' + '��ҩ:' + mainDataArr[37] + '</div>' +
            '<div style="width:120px;float:left ">' + '���:' + mainDataArr[19] + '</div>' +
            '</div>' +
            '<div style="border-bottom:1px solid black;height:20px">' +
            '<div style="width:120px;float:left ">' + '��Һ:' + '</div>' +
            '<div style="width:120px;float:left ">' + '����:' + '</div>' +
            '<div style="width:120px;float:left ">' + 'ҽʦ:' + mainDataArr[22] + '</div>' +
            '</div>';
        labelHtml = headHtml + bodyHtml + footHtml;
        $("#labelContent").html(labelHtml);
    }

})