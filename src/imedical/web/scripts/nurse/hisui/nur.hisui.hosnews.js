/**
 * @author wujiang
 */
var typeObj={
  Fever:["发热",'QueryFeverDetail'],
  OpeToday:["今日手术",'QueryOperationDetail'],
  respirator:["呼吸机",'QueryRespiratorDetail'],
  transfusion:["输血",'QueryTransfusionDetail'],
  catheter:["导尿管",'QueryCatheterDetail'],
  GastricTube:["胃肠管",'QueryGastroenteroscopeDetail'],
  CVC:["CVC",'QueryCVCDetail'],
  PICC:["PICC",'QueryPICCDetail'],
  NewAdmission:["新入",'QueryNewIn'],
  LeaveHosp:["出院",'QueryPatOut'],
  transIn:["转入",'QueryChangeInto'],
  transOut:["转出",'QueryChangeOut'],
}

// https://114.251.235.22:1443/imedical/web/csp/nur.hisui.hosnews.csp?type=Fever^OpeToday^respirator^transfusion^catheter^GastricTube^CVC^PICC^NewAdmission^LeaveHosp&width=145px&height=80px&marginRight=15px&imgWidth=40px&imgMarginLeft=20px&fontSize=20px^14px&lineHeight=18px&MWToken=E520D5118FC9B56FA13AF0D348852DF8
// 第二屏
// Fever^OpeToday^respirator^transfusion^catheter^GastricTube^CVC^PICC^NewAdmission^LeaveHosp&width=151.5px&height=80px&marginRight=15px&imgWidth=40px&imgMarginLeft=20px&fontSize=20px^14px&lineHeight=18px&wrap=10
// 第三屏
// Fever^OpeToday^respirator^transfusion^catheter^GastricTube^CVC^PICC^NewAdmission^LeaveHosp^transIn^transOut&width=187px&height=82px&marginRight=20px&marginBottom=20px&imgWidth=54px&imgMarginLeft=26.3px&fontSize=26px^16px&lineHeight=23px&wrap=4

$(function() {
  // $('#hosnewsStyle').append('.hosnews{width: '+width+';height: '+height+';line-height: '+height+';margin-right: '+marginRight+';}');
  $('#hosnewsStyle').append('.hosnews{width: '+width+';height: '+height+';line-height: '+height+';}');
  // $('#hosnewsStyle').append('.hosnews:nth-of-type('+wrap+'n){margin-right: 0;}');
  // if (marginBottom) $('#hosnewsStyle').append('.hosnews{margin-bottom: '+marginBottom+';}');
  // $('#hosnewsStyle').append('.hosnews:nth-last-of-type(-n+'+wrap+'){margin-bottom: 0;}');
  $('#hosnewsStyle').append('.hosnews>img{width: '+imgWidth+';margin-left: '+imgMarginLeft+';}');
  fontSize=fontSize.split("^");
  $('#hosnewsStyle').append('.hosnews>div>p{height: '+(parseInt(imgWidth)/2)+'px;font-size: '+fontSize[1]+';line-height: '+lineHeight+';}');
  $('#hosnewsStyle').append('.hosnews>div>p:first-of-type{font-size: '+fontSize[0]+';}');
  init();
});
// 初始化
function init() {
  var types=type.split("^");
  for (var i = 0; i < types.length; i++) {
    (function () {
      var j=i;
      var type = types[j];
      if (!$('.hosnews:eq('+j+')').length) {
        $('body').append($('.hosnews:eq(0)').clone())
      }
      $('.hosnews:eq('+j+')>img').attr('src','../images/'+type+'.png');
      // 获取消息信息
      if (fakeFlag) {
        var data=fakeData[typeObj[type][1]];
      } else {
        var data=$cm({
          ClassName: 'Nur.Interface.OutSide.PortalUC.Ward',
          QueryName: typeObj[type][1],
          rows: 9999,
          wardId: session['LOGON.WARDID'],
        }, false);
      }
      $('.hosnews:eq('+j+')>div>p:eq(0)').html(data.total).next().html(typeObj[type][0]);
      // if(!data.total) return;
      $('.hosnews:eq('+j+')').off().click(function(){
        var list = {name:typeObj[type][0],link:window.location.origin+'/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type='+type+'&MWToken=' + websys_getMWToken()};
        console.log(list);
        window.parent.parent.postMessage({embedWindow: list},"*");
      });
    })();
  }
}
setInterval(init, 3*60*1000); // 3分钟刷新一次
