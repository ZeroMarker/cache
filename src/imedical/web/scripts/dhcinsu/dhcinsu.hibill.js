/*
 * FileName: dhcinsu.hibill.js -4101
 * Author: DingSH
 * Modify: Lxy
 * Date: 2022-03-07
 * Description: 医保基金结算结算单
*/
var chsBill = {};
var GV=
{
	   WindPrtnFlag:'N',
	   Rq:''
}
$(function () {
        var data=getChsBillData();
        chsBill.setlinfo = data.setlinfo;
        //填充基础信息
        chsBill.dealBase(data.setlinfo);
        //填充门诊慢特病诊疗信息
        chsBill.dealSpecial(data.opspdiseinfo);
        //填充诊断列表
        chsBill.dealDiag(data.diseinfo);
        //填充手术列表
        chsBill.dealOper(data.oprninfo);
        //填充ICU列表
        chsBill.dealICU(data.icuinfo);
        //填充输血列表
        //chsBill.dealBlood(data.bloodList);
        chsBill.dealBlood(data.bldinfo);
        chsBill.iteminfo = data.iteminfo;
        //填充费用列表
        chsBill.dealFee(data.iteminfo);
        //填充基金支付类型列表
        chsBill.otherPay(data.payinfo);
        
	   //打印
	   $('#btn-print').bind('click', function(){
	        btnprint();
	    })
});

chsBill.dealDate = function (data,type) {
    //yyyy-MM-dd HH:mm:ss
    var dataArray = data ? data.split("-") : null;
    if(!dataArray || dataArray.length<2){
        //yyyy/MM/dd HH:mm:ss
        dataArray = data ? data.split("/") : null;
        if(!dataArray || dataArray.length<2){
            //yyyyMMdd HH:mm:ss
            if(data && data.length >7){
                dataArray[0] = data.substr(0,4);
                dataArray[1] = data.substr(4,2);
                dataArray[2] = data.substr(6);
            }
        }
    }
    var year = (dataArray && dataArray.length>0) ? dataArray[0]:"";
    var month = (dataArray && dataArray.length>1) ? dataArray[1]:"";
    var day = (dataArray && dataArray.length>2) ? dataArray[2]:"";
    var hour = "";
    if(day && ""!=day){
        var da = day.split(":");
        if(day.indexOf(":")>-1 && day.length>2){
            hour = day.substr(day.indexOf(":")-2,2);
        }
        if(day.length>2){
            day = day.substr(0,2);
        }
    }
    chsBill.setlinfo[type+"Year"] = year;
    chsBill.setlinfo[type+"Month"] = month;
    chsBill.setlinfo[type+"Day"] = day;
    chsBill.setlinfo[type+"Hour"] = hour;
    $('#'+type+'Year').html( year );
    $('#'+type+'Month').html( month );
    $('#'+type+'Day').html( day );
    $('#'+type+'Hour').html( hour );
};
//填充基本信息
chsBill.dealBase = function (setlinfo) {
    if(setlinfo){
        for (var fieldCode in setlinfo) {
            if (setlinfo.hasOwnProperty(fieldCode)) {
                var baseData = setlinfo[fieldCode];
                if("dcla_time"==fieldCode){//申报时间
                    chsBill.dealDate(baseData,"dcla_time");
                }else if("brdy"==fieldCode){//出生日期
                    chsBill.dealDate(baseData,"brdy");
                }else if("adm_time"==fieldCode){//入院时间
                    chsBill.dealDate(baseData,"adm_time");
                }else if("dscg_time"==fieldCode){//出院时间
                    chsBill.dealDate(baseData,"dscg_time");
                }else if("setl_begn_date"==fieldCode){//结算开始时间
                    chsBill.dealDate(baseData,"setl_begn_date");
                }else if("setl_end_date"==fieldCode){//结算结束时间
                    chsBill.dealDate(baseData,"setl_end_date");
                }else{
                    $('#' + fieldCode).html(baseData);
                }
            }
        }
    }
};
//填充门诊慢特病诊疗信息
chsBill.dealSpecial= function (specialOperAndDiag) {;
    var specialLength = 0;
    if(null != specialOperAndDiag){
        specialLength = specialOperAndDiag.length;
    }
    var specialArray = [];
    for(var i=0;i<specialLength;i++){
        var sa = [];
        (specialOperAndDiag[i] && specialOperAndDiag[i]["diag_name"]) ? sa.push(specialOperAndDiag[i]["diag_name"]) : sa.push("");
        (specialOperAndDiag[i] && specialOperAndDiag[i]["diag_code"]) ? sa.push(specialOperAndDiag[i]["diag_code"]) : sa.push("");
        (specialOperAndDiag[i] && specialOperAndDiag[i]["oprn_oprt_name"]) ? sa.push(specialOperAndDiag[i]["oprn_oprt_name"]) : sa.push("");
        (specialOperAndDiag[i] && specialOperAndDiag[i]["oprn_oprt_code"]) ? sa.push(specialOperAndDiag[i]["oprn_oprt_code"]) : sa.push("");
        specialArray.push(sa);
    }
    // chsBill.specialArray = specialArray;
    var specialTrs = '';
    if(specialArray.length>0){
        $.each(specialArray,function (i,spa) {
            specialTrs += '<tr>';
            $.each(spa,function (j,data) {
                specialTrs += '<td>'+data+'</td>';
            });
            specialTrs += '</tr>';
        });
    }else{
        specialTrs +='<tr><td></td><td></td><td></td><td></td></tr>';
    }
    $('#slowDisease').append(specialTrs);
};
//填充诊断列表
chsBill.dealDiag= function (diseinfo) {
    var diagTrs = '<tr class="title"><td>出院西医诊断</td><td>疾病代码</td><td>入院病情</td><td>出院中医诊断</td><td>疾病代码</td><td>入院病情</td></tr>';
    if (diseinfo && diseinfo.length>0){
        //分离各种诊断
        var diag1 = [];//西医主要诊断
        var diag2 = [];//西医其他诊断
        var diag3 = [];//中医主病
        var diag4 = [];//中医主证
        for (var i=0;i<diseinfo.length;i++){
            var obj = diseinfo[i];
            switch (obj["diag_type"]){
                case '1':
                    diag1.push(obj);
                    break;
                case '2':
                    diag2.push(obj);
                    break;
                case '3':
                    diag3.push(obj);
                    break;
                case '4':
                    diag4.push(obj);
                    break;
            }
        }

        //进行主要诊断和主病的拼接（不管有没有都要拼接一行）
        //防止出现Cannot read property 'xxx' of undefined
        if (diag1[0] == undefined) { diag1[0] = {}; }
        if (diag3[0] == undefined) { diag3[0] = {}; }
        diagTrs +='<tr>';
        diagTrs += '<td>'+'主要诊断：'+'<span title="西医诊断">'+chsBill.dealNumber(diag1[0]["diag_name"])+'</span></td>';
        diagTrs += '<td><span title="西医疾病代码">'+chsBill.dealNumber(diag1[0]["diag_code"])+'</span></td>';
        diagTrs += '<td><span title="西医入院病情">'+chsBill.dealNumber(diag1[0]["adm_cond_type"])+'</span></td>';
        diagTrs += '<td>'+'主病：'+'<span title="中医诊断">'+chsBill.dealNumber(diag3[0]["diag_name"])+'</span></td>';
        diagTrs += '<td><span title="中医疾病代码">'+chsBill.dealNumber(diag3[0]["diag_code"])+'</span></td>';
        diagTrs += '<td><span title="中医入院病情">'+chsBill.dealNumber(diag3[0]["adm_cond_type"])+'</span></td>';
        diagTrs +='</tr>';

        //进行其他诊断和主证的拼接（不管有没有都要拼接一行）
        var length = diag2.length>diag4.length?diag2.length:diag4.length;
        if (diag2.length == 0 && diag4.length == 0){
            length = 1;
        }
        for (var i=0;i<length;i++){
            //防止出现Cannot read property 'xxx' of undefined
            if (diag2[i] == undefined) { diag2[i] = {}; }
            if (diag4[i] == undefined) { diag4[i] = {}; }
            diagTrs +='<tr>';
            diagTrs += '<td>'+((i==0)?'其他诊断：':'')+'<span title="西医诊断">'+chsBill.dealNumber(diag2[i]["diag_name"])+'</span></td>';
            diagTrs += '<td><span title="西医疾病代码">'+chsBill.dealNumber(diag2[i]["diag_code"])+'</span></td>';
            diagTrs += '<td><span title="西医入院病情">'+chsBill.dealNumber(diag2[i]["adm_cond_type"])+'</span></td>';
            diagTrs += '<td>'+((i==0)?'主证：':'')+'<span title="中医诊断">'+chsBill.dealNumber(diag4[i]===undefined?"":diag4[i]["diag_name"])+'</span></td>';
            diagTrs += '<td><span title="中医疾病代码">'+chsBill.dealNumber(diag4[i]===undefined?"":diag4[i]["diag_code"])+'</span></td>';
            diagTrs += '<td><span title="中医入院病情">'+chsBill.dealNumber(diag4[i]===undefined?"":diag4[i]["adm_cond_type"])+'</span></td>';
            diagTrs +='</tr>';
        }
    }else{
        diagTrs +='<tr><td>主要诊断：</td><td></td><td></td><td>主病：</td><td></td><td></td></tr>';
        diagTrs +='<tr><td>其他诊断：</td><td></td><td></td><td>主证：</td><td></td><td></td></tr>';
    }

    diagTrs +='<tr><td colspan="6"><div class="field">诊断代码计数<span class="field" id="diag_code_cnt">'+chsBill.dealNumber(chsBill.setlinfo["diag_code_cnt"])+'</span></div></td></tr>';
    $('#diseinfo').append(diagTrs);
};
//填充手术列表
chsBill.dealOper=function(oprninfo){
    var operArray = [];
    //筛选主要诊断
    var opera = [];
    var index=-1;
    for(var i=0;i<oprninfo.length;i++){
        var obj = oprninfo[i];
        if(obj && obj["oprn_oprt_type"] && obj["oprn_oprt_type"]=="1"){
            index= i;
            opera = oprninfo.slice(i,i+1);
            break;
        }
    };
    if(index >-1){
        oprninfo.splice(index,1);//删除主要手术
    }
    operArray = opera.concat(oprninfo);
    var operTrs = '';
    if(operArray && operArray.length>0){
        var operType = '主要'
        var operIndex = ''
        for(var i=0;i<operArray.length;i++) {
            if (i>0) {
                operType = '其他';
                operIndex = i
            }
            operTrs +='<tr class="title"><td width="30%">'+operType+'手术及操作名称'+operIndex+'</td><td width="20%">'+operType+'手术及操作代码'+operIndex+'</td><td width="10%">麻醉方式</td><td width="10%">术者医师姓名</td><td width="10%">术者医师代码</td><td width="10%">麻醉医师姓名</td><td width="10%">麻醉医师代码</td></tr>'
            operTrs +='<tr>';
            operTrs +='<td><span title="手术及操作名称" class="field" data-resume id="operName'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oprn_oprt_name"])+'</span></td>';
            operTrs +='<td><span title="手术及操作代码" class="field" data-resume id="operCode'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oprn_oprt_code"])+'</span></td>';
            operTrs +='<td><span title="麻醉方式" class="field" data-resume id="anesthesiaWayDesc'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["anst_way"])+'</span></td>';
            operTrs +='<td><span title="术者医师姓名" class="field" data-resume id="operDocName'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oper_dr_name"])+'</span></td>';
            operTrs +='<td><span title="术者医师代码" class="field" data-resume id="operDocCode'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oprn_oprt_code"])+'</span></td>';
            operTrs +='<td><span title="麻醉医师姓名" class="field" data-resume id="anesthesiaDocName'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["anst_dr_name"])+'</span></td>';
            operTrs +='<td><span title="麻醉医师代码" class="field" data-resume id="anesthesiaDocCode'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["anst_dr_code"])+'</span></td>';
            operTrs +='</tr>';
            operTrs +='<tr><td colspan="7"><div class="field">手术及操作起止时间<span title="手术及操作起止时间" class="field" data-resume id="operDateStr'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oprn_oprt_date"])+(chsBill.dealNumber(operArray[i]["oprn_oprt_date"])===''?'':'~')+chsBill.dealNumber(operArray[i]["oprn_oprt_endtime"])+'</span></div>';
            operTrs +='<div class="field">麻醉起止时间<span title="麻醉起止时间" class="field" data-resume id="anesDateStr'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["anst_begntime"])+(chsBill.dealNumber(operArray[i]["anst_begntime"])===''?'':'~')+chsBill.dealNumber(operArray[i]["anst_endtime"])+'</span></div></td></tr>';
        }
        if(operArray.length===1){
            operTrs +='<tr class="title"><td width="30%">其他手术及操作名称</td><td width="20%">其他手术及操作代码</td><td width="10%">麻醉方式</td><td width="10%">术者医师姓名</td><td width="10%">术者医师代码</td><td width="10%">麻醉医师姓名</td><td width="10%">麻醉医师代码</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
            operTrs +='<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
            operTrs +='<tr><td colspan="7"><div class="field">手术及操作起止时间<span title="手术及操作起止时间" class="field"></span></div><div class="field">麻醉起止时间<span title="麻醉起止时间" class="field"></span></div></td></tr>';
        }
    } else {
        operTrs +='<tr class="title"><td width="30%">主要手术及操作名称</td><td width="20%">主要手术及操作代码</td><td width="10%">麻醉方式</td><td width="10%">术者医师姓名</td><td width="10%">术者医师代码</td><td width="10%">麻醉医师姓名</td><td width="10%">麻醉医师代码</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        operTrs +='<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        operTrs +='<tr><td colspan="7"><div class="field">手术及操作起止时间<span title="手术及操作起止时间" class="field"></span></div><div class="field">麻醉起止时间<span title="麻醉起止时间" class="field"></span></div></td></tr>';
        operTrs +='<tr><td colspan="7"><div class="field">手术及操作代码计数<span class="field"></span></td></tr>';
        operTrs +='<tr class="title"><td width="30%">其他手术及操作名称</td><td width="20%">其他手术及操作代码</td><td width="10%">麻醉方式</td><td width="10%">术者医师姓名</td><td width="10%">术者医师代码</td><td width="10%">麻醉医师姓名</td><td width="10%">麻醉医师代码</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        operTrs +='<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        operTrs +='<tr><td colspan="7"><div class="field">手术及操作起止时间<span title="手术及操作起止时间" class="field"></span></div><div class="field">麻醉起止时间<span title="麻醉起止时间" class="field"></span></div></td></tr>';
    }
    operTrs +='<tr><td colspan="7"><div class="field">手术及操作代码计数<span class="field" id="oprn_oprt_code_cnt">'+chsBill.dealNumber(chsBill.setlinfo["oprn_oprt_code_cnt"])+'</span></div></td></tr>';
    $("#oprninfo").append(operTrs);
};
//填充ICU列表
chsBill.dealICU=function(icuinfo){
    var icuTrs = '<tr class="title"><td width="35%"><span>重症监护病房类型</span><br/><span>(CCU、NICU、EICU、SICU、PICU、RICU、ICU(综合)、其他)</span></td><td width="20%"><span>进重症监护室时间</span><br/><span>(_年_月_日_时_分)</span></td><td width="20%"><span>出重症监护室时间</span><br/><span>(_年_月_日_时_分)</span></td><td width="25%">合计（_时_分）</td></tr>';
    if(icuinfo && icuinfo.length>0){
        for(var i=0;i<icuinfo.length;i++){
            icuTrs +='<tr>';
            icuTrs +='<td>'+(icuinfo[i]["scs_cutd_ward_type"] ? icuinfo[i]["scs_cutd_ward_type"]:"")+'</td>';
            icuTrs +='<td>'+(icuinfo[i]["scs_cutd_inpool_time"] ? icuinfo[i]["scs_cutd_inpool_time"]:"")+'</td>';
            icuTrs +='<td>'+(icuinfo[i]["scs_cutd_exit_time"] ? icuinfo[i]["scs_cutd_exit_time"]:"")+'</td>';
            icuTrs +='<td>'+(icuinfo[i]["ICU_HOUR"] ? icuinfo[i]["ICU_HOUR"]:"")+'</td>';
            icuTrs +='</tr>';
        }
    }else{
        icuTrs +='<tr><td></td><td></td><td></td><td></td></tr>';
    }
    $("#icuinfo").append(icuTrs);
};

//填充输血列表
chsBill.dealBlood=function(bloodList){
    var bloodTrs = '<tr class="title"><td width="35%"><span>输血品种</span></td><td><span>输血量</span></td><td width="25%">输血计量单位</td></tr>';
    if(bloodList && bloodList.length>0){
        for(var i=0;i<bloodList.length;i++){
            bloodTrs +='<tr>';
            bloodTrs +='<td><span title="输血品种" class="field" data-resume id="bloodType'+bloodList[i]["bld_cat"]+'">'+bloodList[i]["bld_cat"]+'</span></td>';
            bloodTrs +='<td><span title="输血量" class="field" data-resume id="bloodValue'+bloodList[i]["bld_amt"]+'">'+chsBill.dealNumber(bloodList[i]["bld_amt"])+'</span></td>';
            bloodTrs +='<td><span title="输血计量单位" class="field" data-resume id="bloodUnit'+bloodList[i]["bld_unt"]+'">'+bloodList[i]["bld_unt"]+'</span></td>';
            bloodTrs +='</tr>';
        }
    }else{
        bloodTrs +='<tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr>';
    }
    $("#bloodList").append(bloodTrs);
};

//填充费用列表
chsBill.dealFee=function(iteminfo){
    var feeTrs = '<tr><td style="width:25%">项目名称</td><td style="width:15%">金额</td><td style="width:15%">甲类</td><td style="width:15%">乙类</td><td style="width:15%">自费</td><td style="width:15%">其他</td></tr>';
    if(iteminfo){
        var totalObj = {"med_chrgitm_desc":"金额合计","med_chrgitm":"feeTotal","amt":chsBill.dealNumber(chsBill.setlinfo["amt_total"]),
            "claa_sumfee":chsBill.dealNumber(chsBill.setlinfo["claa_sumfee_total"]),
            "clab_amt":chsBill.dealNumber(chsBill.setlinfo["clab_amt_total"]),
            "fulamt_ownpay_amt":chsBill.dealNumber(chsBill.setlinfo["fulamt_ownpay_amt_total"]),
            "oth_amt":chsBill.dealNumber(chsBill.setlinfo["oth_amt_total"])};
        iteminfo.push(totalObj);
        for(var m=0;m<iteminfo.length;m++){
            feeTrs +='<tr>';
            feeTrs +='<td><span title="项目名称">'+chsBill.dealNumber(iteminfo[m]["med_chrgitm_desc"])+'</span></td>';
            feeTrs +='<td><span title="金额" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'">'+chsBill.dealNumber(iteminfo[m]["amt"])+'</span></td>';
            feeTrs +='<td><span title="甲类" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'A">'+chsBill.dealNumber(iteminfo[m]["claa_sumfee"])+'</span></td>';
            feeTrs +='<td><span title="乙类" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'B">'+chsBill.dealNumber(iteminfo[m]["clab_amt"])+'</span></td>';
            feeTrs +='<td><span title="自费" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'C">'+chsBill.dealNumber(iteminfo[m]["fulamt_ownpay_amt"])+'</span></td>';
            feeTrs +='<td><span title="其他" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'O">'+chsBill.dealNumber(iteminfo[m]["oth_amt"])+'</span></td>';
            feeTrs +='</tr>';
        }
        $("#feeList").append(feeTrs);
    }
}

//填充其他支付类型列表
chsBill.otherPay=function(payinfo){
    var fundDataArray = [];
    if(payinfo && payinfo.length>0){
	    var j=0
        for(var i=0;i<payinfo.length;i++){
            var dataArray = [];
            var fee = payinfo[i];
            if (fee["oth_pay_flag"]=="1")  //其他基金支付分项标志
            {
               dataArray.push(fee["fund_pay"]?fee["fund_pay"]:'');
               if(fee["fund_payamt"] || fee["fund_payamt"]==0){
                dataArray.push(fee["fund_payamt"]);
               }else{
                dataArray.push('');
               }
                dataArray.push(fee["fund_pay_type"]);
                fundDataArray.push(dataArray);
                j=j+1;
            }
        }
        //至少要有2行数据
        if(fundDataArray.length===1){
            fundDataArray.push(['','','']);
        }
        if(fundDataArray.length===0){
            fundDataArray.push(['','','']);
            fundDataArray.push(['','','']);
        }
        
    }else{//至少要有2行数据
        fundDataArray.push(['','','']);
        fundDataArray.push(['','','']);
    }

    var rows = fundDataArray.length;
    var rowspan1 = Math.round(rows/2);
    var rowspan2 = rows - rowspan1;
    var trs = '';
    for(var i=0; i < rows; i++){
        var feeName = chsBill.dealNumber(fundDataArray[i][0]);
        var feeCode = fundDataArray[i][2];
        var feeValue = chsBill.dealNumber(fundDataArray[i][1]);
        if (i === 0) {
            trs = '<tr>' +
                '<td rowspan="'+rows+'" width="20%" class="font-bold">其他支付</td>' +
                '<td width="20%">'+feeName+'</td>' +
                '<td width="15%"><span class="field" id="'+feeCode+'OtherFee">'+feeValue+'</span></td>' +
                '<td rowspan="'+rows+'" width="15%" class="font-bold">个人负担</td>' +
                '<td rowspan="'+rowspan1+'" width="15%">个人账户支付</td>' +
                '<td rowspan="'+rowspan1+'"><span class="field" id="acct_pay">'+chsBill.dealNumber(chsBill.setlinfo.acct_pay)+'</span></td>' +
                '</tr>'
        } else if (i === rowspan1) {
            trs += '<tr><td>'+feeName+'</td><td><span class="field" id="'+feeCode+'OtherFee">'+feeValue+'</span></td><td rowspan="'+rowspan2+'">个人现金支付</td><td rowspan="'+rowspan2+'"><span class="field" id="psn_cashpay">'+chsBill.dealNumber(chsBill.setlinfo.psn_cashpay)+'</span></td></tr>'
        } else {
            trs += '<tr><td>'+feeName+'</td><td><span class="field" id="'+feeCode+'OtherFee">'+feeValue+'</span></td></tr>'
        }
    }
    $("#payList").append(trs);
};
chsBill.dealNumber=function (data) {
    if(data || data==0){
        return data;
    }else{
        return '';
    }
};

/*
  获取基金结算清单数据
*/
function getChsBillData(){
	GV.Rq="";
	var Rq = INSUGetRequest();  //dhcinsu/common/dhcinsu.common.js
	var InDivDr = Rq["InDivDr"]; 
	var AdmDr = Rq["AdmDr"]; 
	var EId = Rq["EId"];
	var UpFag = Rq["UpFag"]; 
	var Infno = Rq["Infno"]; 
	var CkVal = Rq["CkVal"]; 
	var InputInfo = Rq["InputInfo"]; 
	var InArgType = Rq["InArgType"]; 
	var OutArgType = Rq["OutArgType"]; 
	GV.Rq=Rq ;    
	var options={
		ClassName:"web.DHCINSUEprUl",
		MethodName:"GetEprStr",
		DivDr: InDivDr,
		EId: EId,
		Infno:Infno
	   }
	   
	/*if((UpFag=="上传成功")||(((UpFag=="上传失败"))&&(!CkVal)))
	{
		var options={
		ClassName:"web.DHCINSUEprUl",
		//MethodName:"GetErpiInargInfo",
		//DivDr: InDivDr,
		//UploadId: EId,
		MethodName:"GetEprStr",
		DivDr: InDivDr,
		EId: EId,
		Infno:Infno
	   }
	}
    else
	{
	 //医保类型^接口编号^医院ID^操作员ID^0^102^1^就诊号^InsuDivID
	 var options={
		ClassName:"INSU.OFFBIZ.BL.BIZ00A",
		MethodName:"InsuSettlementUL",
		InputInfo: InputInfo,
		InArgType: InArgType,
		OutArgType:OutArgType
	 }
	}*/
	var ret=$m(options,false);
	try{
		var data=JSON.parse(ret);
		return  data.input;
		
	}catch(ex){
		 $.messager.alert('提示', '清单JSON反序列化异常ex'+ex.message+","+ret , 'error');
		 return false;
		}
	 return data;
}
function btnprint(){
	/*
     var params = "&DivDr=" +GV.Rq["InDivDr"]+"&EId=" +GV.Rq["EId"]+"&Infno="+GV.Rq["Infno"] ;
	 var fileName = "dhcinsu.hibill-4101.rpx" + params;
	 DHCCPM_RQPrint(fileName, ($(window).width()), $(window).height());
	*/
	
	var params = "DivDr=" + GV.Rq["InDivDr"] + ";" + "EId=" +GV.Rq["EId"] + ";" + "Infno=" + GV.Rq["Infno"]; 
	var fileName = "dhcinsu.hibill-4101.rpx";
	fileName = "{" + fileName + "(" + params + ")}";
	DHCCPM_RQDirectPrint(fileName);
	if(GV.WindPrtnFalg =="Y") {
	   $("#btn-print").hide();
	   preview(1);
	   $("#btn-print").show();
	}
}
function preview(mode)
{
	if (mode < 10){
		buildData()
		var body = window.document.body.innerHTML;
		var form = $("#printdiv").html();
		window.document.title="";
		window.document.body.innerHTML = form;
		window.print();
		window.document.body.innerHTML = body;
		
	} else {
		window.print();
	}
}

function buildData(){
	//绑定 type=text, 同时如果checkbox,radio,select>option的值有变化, 也绑定一下, 这里忽略button
	$("input,select option").each(function(){
		$(this).attr('value',$(this).val());
	});
	
	//绑定 type=checkbox,type=radio 选中状态
	$("input[type='checkbox'],input[type='radio']").each(function(){
		if($(this).attr('checked'))
			$(this).attr('checked',true);
		else
			$(this).removeAttr('checked');
	});
	
	//绑定 select选中状态
	$("select option").each(function(){
		if($(this).attr('selected'))
			$(this).attr('selected',true);
		else
			$(this).removeAttr('selected');
	});
	
	//绑定 textarea
	$("textarea").each(function(){
		$(this).html($(this).val());
	});
	
}