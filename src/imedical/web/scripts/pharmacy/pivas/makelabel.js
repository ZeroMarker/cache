/** 
 * ģ��: 	 ��Һ��ǩ����-����html��ʽ��ǩ,appendǰ̨��ʾ��
 * ��д����: 2019-06-03
 * ��д��:   dinghongying
 */
var PIVASLABEL = ({
	Template:'',
    Init: function(_options) {
	    this.Template=$('#tempPivasLabel').html();
        var labelData = JSON.parse(_options.labelData);
        var template = $('#tempPivasLabel').html();
        var handler = Handlebars.compile(template);
        $("#labelContent").html(handler(labelData));
        // ����ά��
        var qrcode = new QRCode($('.pivas-label-qrcode')[0], {
            text: labelData.barCode,
            width: 70,
            height: 70,
            colorDark: '#000000',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.L
        });
        
    }

})