/*
 * @Author: qunianpeng
 * @Date: 2022-08-18 11:02:31
 * @Descripttion: 药品详情控件
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-08-18 12:50:15
 */
class DrugDetail {

    constructor(data) {
        this.data = data;           
    }
    
    init() {

        var htmlArr = [];
        if (this.data == '') {
            return;
        }
        var drugData = this.data;
        var details = "" //'<div class="details clearfix">';
        htmlArr.push(details);
        var conter = ' <div class="d_conter">';
        htmlArr.push(conter);
    
    	var genername = drugData.instru["genername"]||""
        // 标题
        var title = '<h2 class="nowrap" id="genername">' + genername + '</h2>';
        htmlArr.push(title);
    
        // 概要信息 Overview
        var overtable = this.createOverDrugTable();
        htmlArr.push(overtable);
    
    	// 同源药品信息
    	var origintable = this.createOriginTable();
    	htmlArr.push(origintable);
    	
        // 目录信息
        var libtable = this.createLibary();
        htmlArr.push(libtable)
    
        // 药品详情信息
        var drugcont = this.createDrugCont();
        htmlArr.push(drugcont);
        htmlArr.push('</div>');
        
        // 图谱标识
        htmlArr.push('<div class="d_right">');
        if ("undefined"!==typeof websys_getMWToken){
		 	htmlArr.push('<div class="d_know" data-id="'+ drugData.id +'"><a href="dhcckb.wiki.grap2.csp?IncId='+drugData.id +'&MWToken='+websys_getMWToken()+'" target="blank"><div class="d_know_tips">知识图谱</div></a></div>');
       	}else{
	    	htmlArr.push('<div class="d_know" data-id="'+ drugData.id +'"><a href="dhcckb.wiki.grap2.csp?IncId='+drugData.id +'" target="blank"><div class="d_know_tips">知识图谱</div></a></div>');
        }
                
        // 相关文献
        var linkbooks = this.createLinkBooks();
        htmlArr.push(linkbooks);
    
        // 锚点信息
        var anchorhtml = this.createAnchor();
        htmlArr.push(anchorhtml);
        htmlArr.push('</div>');    
        //htmlArr.push('</div>');    
        
        return htmlArr.join('');
    }
    /**
     * @description: 动态创建概要信息
     * @param {*} 
     * @return {*}
     */
    createOverDrugTable() {
        var drugData = this.data;
        var overArr = drugData.overview; //arr
        if (overArr.length <= 0) {
            return;
        }
		// 通用模板
        var str = `
        <table class="tb_schema" cellpadding="0" cellspacing="0">
            <tr>
                <td id="genername">{{genernametitle}}</td>
                <td>{{genername}}</td>
                <td id="proname">{{pronametitle}}</td>
                <td>{{proname}}</td>
            </tr>
            <tr>
                <td id="form">{{formtitle}}</td>
                <td>{{form}}</td>
                <td id="spec">{{spectitle}}</td>
                <td>{{spec}}</td>
            </tr>
                <tr>
                <td id="approvalnum">{{approvalnumtitle}}</td>
                <td>{{approvalnum}}</td>
                <td id="manf">{{manftitle}}</td>
                <td>{{manf}}</td>
            </tr>
        </table>
        `; 
        
        // 中药饮片模板
        var yp_str = `
        <table class="tb_schema" cellpadding="0" cellspacing="0">
            <tr>
                <td id="genername">{{genernametitle}}</td>
                <td>{{genername}}</td>
                <td id="nationalSICode">{{nationalSICodetitle}}</td>
                <td>{{nationalSICode}}</td>
                </tr>
            <tr>
                <td id="latinname">{{latinnametitle}}</td>
                <td>{{latinname}}</td>
                <td id="othername">{{othernametitle}}</td>
                <td>{{othername}}</td>
            </tr>
        </table>
        `;
        var drugType = drugData.type;
        var reghtml = (drugType =="yp")?yp_str:str;
        var titleObj = drugData.title; // obj
        var instruObj = drugData.instru;

        overArr.forEach(function (item, index) {
            var reg = new RegExp("{{" + item + "title" + "}}", "g");
            reghtml = reghtml.replace(reg, titleObj[item] || "");
            var reg2 = new RegExp("{{" + item + "}}", "g");
            reghtml = reghtml.replace(reg2, instruObj[item] || "");
        });
        
        return reghtml;
    }
	
	
	/**
     * @description: 动态创建同源药品信息
     * @param {*} 
     * @return {*}
     */
    createOriginTable() {
		var originArr = this.data.origin;
        if (originArr.length <= 0) {
            return;
        }
        
        var originHtml = [];
        originHtml.push('<div class="d_origin" >');
        originHtml.push('<h4>同源药品<span>('+ originArr.length +'条)</span></h4>');
        originHtml.push('<table cellpadding="0" cellspacing="0">');
        originHtml.push('<thead><tr><th>规格</th><th>批准文号</th><th>生产厂家</th></tr></thead>');
       	originHtml.push('<tbody>');
       	var trArr = [];
        originArr.forEach(function (item, index) {
        	var $tr = '<tr>';
        	$tr +=  '<td>'+ item.spec +'</td>';
        	$tr +=  '<td>'+ item.approvalnum +'</td>';
        	$tr +=  '<td>'+ item.manf +'</td>';
        	$tr += '</tr>';
        	trArr.push($tr);
        });
		originHtml.push(trArr.join(''));
		originHtml.push('</tbody>');
		originHtml.push('</table>');
		originHtml.push('</div>');   
		
		return originHtml.join('');
	}
	
    /**
     * @description: 动态创建目录信息
     * @param {*} params
     * @return {*}
     */
    createLibary() {
        var drugData = this.data;
        var libObj = drugData.title; 
        if (JSON.stringify(libObj) === '{}') {
            return;
        }
        var libstr = "";     
        libstr += '<div class="d_libary clearfix">';
        libstr += '<dl><dt><img src="../scripts/dhcnewpro/dhcckb/pdss/images/libary.png"><h3>目录</h3></dt></dl>';
         
        var dlArr = [];       
        var count = 0;
        var libObjLen = Object.keys(libObj).length;
        for (var key in libObj) { 
        	if ((drugData.instru[key]=="")||(drugData.instru[key]==undefined)){
	        	continue;
        	}        	
        	var remainder = count % 8;
			var $ddstr = '<dd class="nowrap"><a href="#'+ key +'">'+ parseInt(count+1) +'.'+ libObj[key] +'</a></dd>';
			if (remainder == 0){	// 8个数据一个dl  
        		libstr += '<dl><dt>'+$ddstr;
	    	}else if((remainder == 7)||(count == libObjLen)) {
		   		 libstr += $ddstr+'</dt></dl>';  		 
		   	}else{	
				libstr += $ddstr;  	
			}
			count++; 			
        }
        libstr += '</div>';
        return libstr;
    }

    /**
     * @description: 动态创建详情信息
     * @param {*} params
     * @return {*}
     */
    createDrugCont() {
        var drugData = this.data;
        var titleObj = drugData.title; 
        if (JSON.stringify(titleObj) === '{}') {
            return;
        }
        var instruObj = drugData.instru; 
        if (JSON.stringify(instruObj) === '{}') {
            return;
        }
        
        
        var overArr = drugData.overview;
        var contArr = [];
        contArr.push('<div class="d_cont">');
        for (var key in instruObj) {
            //  概要信息中已经输出的内容不在重复输出
            if (overArr.indexOf(key) != -1) {
                continue;
            }
            // 说明书为空，不显示title
            if (instruObj[key]||"" != "") {
                contArr.push('<div class="d_cont_title">');
                contArr.push('<h3 class="nowrap" id="'+ key +'">'+ titleObj[key] +'</h3>');
                contArr.push('</div>');
                contArr.push('<div class="d_cont_text">');
                contArr.push('<span>'+ instruObj[key] +'</span>');
                contArr.push('</div>');       
            }
           
        }
        contArr.push('</div>');

        return contArr.join('');
    }

    /**
     * @description: 动态创建相关文献信息
     * @param {*} drugData
     * @return {*}
     */
    createLinkBooks() {
        var drugData = this.data;
        var linkbookArr = drugData.linkbooks;
        // linkbooks: [{
        //                 id: '',
        //                 name: ''
        //             }]
        if (linkbookArr.length <=0 ) {
            return;
        }
        var linkhtmlArr = [];
        linkhtmlArr.push('<div class="d_linkbooks">');
        linkhtmlArr.push('<h4>相关文献</h4>');

        linkbookArr.forEach(function (item, index) {
            linkhtmlArr.push( '<a class="nowrap" target="_blank" href="'+ item.href +'">'+ item.name +'</a>');        
        });
        linkhtmlArr.push('</div>');
        return linkhtmlArr.join('');
    }

    /**
     * @description: 动态创建锚点信息
     * @param {*} drugData
     * @return {*}
     */
    createAnchor() {
        var drugData = this.data;
        var titleObj = drugData.title;
        if (JSON.stringify(titleObj) === '{}') {
            return "";
        }
        
        var anchorArr = [];
        drugData.linkbooks.length == 0?anchorArr.push('<div class="d_anchor scrollbar" style="margin-top:20px">'):anchorArr.push('<div class="d_anchor scrollbar">');
        
        //anchorArr.push('<div class="d_anchor scrollbar">');
        anchorArr.push('<ul class="anchor_list">');
        anchorArr.push('<li><div class="circle"></div><a class="anchor_txt"></a></li>');
        var count = 0;
        for (var key in titleObj) {
	        if ((drugData.instru[key]=="")||(drugData.instru[key]==undefined)){
	        	continue;
        	}
	        count++;
	        var $li = "";
	        if (count == 1){
	        	var $li ='<li class="active"><div class="circle_check"></div><div class="line"></div><a href="#'+ key +'" class="anchor_txt_check">'+ count +'.'+ titleObj[key] +'</a></li>';
	        }
           	else{
	        	var $li ='<li><div class="circle"></div><div class="line"></div><a href="#'+ key +'" class="anchor_txt">'+ count +'.'+ titleObj[key] +'</a></li>';
	        } 
	        anchorArr.push($li);    
	             
        }
        anchorArr.push('</ul>');        
        anchorArr.push('</div>');
        return anchorArr.join('');
    }

}
