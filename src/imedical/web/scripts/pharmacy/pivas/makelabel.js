/** 
 * 模块: 	 配液标签公共-创建html格式标签,append前台显示用
 * 编写日期: 2019-06-03
 * 编写人:   dinghongying
 */
var PIVASLABEL = ({
	Template:'',
    Init: function(_options) {
	    this.Template=$('#tempPivasLabel').html();
        var labelData = JSON.parse(_options.labelData);
        var template = $('#tempPivasLabel').html();
        var handler = Handlebars.compile(template);
        $("#labelContent").html(handler(labelData));
        // 生二维码
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