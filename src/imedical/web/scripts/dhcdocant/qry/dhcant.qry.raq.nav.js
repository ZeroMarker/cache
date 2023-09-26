/**
 * dhcant.qry.raq.nav.js - KJ QRY Nav Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2017-2018 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-05-02
 * 
 */
 $(function(){
	var kpiObj = {kpi:"",dim:"",kpiNum:"",dimNum:"",content:"",filterRule:"无"};
	
	$(".panel-heading a").on("click", function(){
		var $parentNode = $(this).parent().parent();
		var $si = $parentNode.find("i");
		
		if (!$parentNode.hasClass("c-active")) {
			setMenuStye();
			$parentNode.addClass("c-active").css('background','rgb(27,161,226)');
			$(this).css('color', '#fff');
			$si.css('color', '#fff');
		} else {
			$parentNode.removeClass("c-active").removeAttr('style'); 
			$(this).removeAttr('style'); 
			$si.removeAttr('style'); 
		}
			
	});
	
	var setMenuStye = function() {
		$(".panel-heading").each(function(index, ele){
			if ($(this).hasClass("c-active")) {
				$(this).removeClass("c-active").removeAttr('style'); 
				$(this).find("a").removeAttr('style'); 
				$(this).find("i").removeAttr('style'); 
			}
			
		});
	};
	var clearKPIObj = function() {
		kpiObj.kpi = "";
		kpiObj.kpiNum = "";
		kpiObj.dim = "";
		kpiObj.dimNum = "";
		kpiObj.filterRule = "无";
	}
	var setKPI = function(name) {
		clearKPIObj();
		if (name == "KJ-UseDrug") {	//抗菌用药分析
			kpiObj.kpi = "KP1232,KP1229,KP1236,KP1239,KP1246,KP1247,KP1261,KP1267,KP1268,KP1270,KP1280,KP1284,KP1285,KP1290,KP1291,KP1293,KP1294,KP1296,KP1297,KP1301,KP1259,KP1248";
			kpiObj.kpiNum = 22;
			kpiObj.dim = "CTLOC、Doc、AdmType、IsAnti、IsKSS1、IsKSS2、IsKSS3、XYPresc、CYPresc、ZCYPresc、IsInject、IsBaseDrug、IsSJBaseDurg、IsAntiInject、WARD、ItemCat、ARCIMID";
			kpiObj.dimNum = 17;
		} else if (name == "KPI-Analysis") {
			kpiObj.kpi = "KP1230,KP1231,KP1232,KP1234,KP1250,KP1251,KP1259,KP1261,KP1280";
			kpiObj.kpiNum = 9;
			kpiObj.dim = "CTLOC,Doc,AdmType,WARD,ItemCat,ARCIM";
			kpiObj.dimNum = 6;
		} else if (name == "SEEK-ALL") {
			kpiObj.kpi = "KP1259,KP1261,KP1281,KP1282,KP1283,KP1285,KP1284,KP1286,KP1287,KP1301,KP1302,KP1260:disWard^disLoc^admDoc,KP1290,KP1291,KP1295,KP1292,KP1296,KP1293,KP1297,KP1294,KP1247,KP1248,KP1298,KP1299,KP1300";
			kpiObj.kpiNum = 25;
			kpiObj.dim = "WARD,CTLOC,Doc";
			kpiObj.dimNum = 3;
		} else if (name == "SEEK-LOC") {
			kpiObj.kpi = "KP1259,KP1261,KP1281,KP1282,KP1283,KP1285,KP1284,KP1286,KP1287,KP1301,KP1302,KP1260:disWard^disLoc^admDoc,KP1290,KP1291,KP1295,KP1292,KP1296,KP1293,KP1297,KP1294,KP1247,KP1248,KP1298,KP1299,KP1300";
			kpiObj.kpiNum = 25;
			kpiObj.dim = "WARD,CTLOC,Doc";
			kpiObj.dimNum = 3;
		} else if (name == "SEEK-INFO") {
			kpiObj.kpi = "KP1577:admid.P001^admid.P002^admid.P003^admid.P004^admid.P005^admid.P006^admid.P007^admid.P008^admid.P009^admid.P010^admid.P011^admid.P012^admid.P013^admid.P014^admid.P015^admid.P016^admid.P017^admid.P018^admid.P019^admid.P020^admid.P021^admid.P022^admid.P023^admid.P024^admid.P025^admid.P026^admid.P027";
			kpiObj.kpiNum = 1;
			kpiObj.dim = "维度顺序已经在指标中指定了";
			kpiObj.dimNum = 27;
			kpiObj.filterRule = '"KP1577:({admid.P001}EqualIgNull"+@IsAnti+"&&{admid.P002}EqualIgNull"+@IsUnLimAnti+"&&{admid.P003}EqualIgNull"+@IsLimAnti+"&&{admid.P004}EqualIgNull"+@IsSpAnti+"&&{admid.P005}EqualIgNull"+@IsIcutYF+"&&{admid.P006}EqualIgNull"+@IsIcut+"&&{admid.P007}EqualIgNull"+@IsIcut2h+"&&{admid.P008}EqualIgNull"+@IsIcut24h+"&&{admid.P009}EqualIgNull"+@IsIcutYfHL+"&&{admid.P028}EqualIgNull"+@AntCnt+"&&{admid.P011}EqualIgNull"+@IsSjBF+"&&{admid.P012}EqualIgNull"+@IsmedAnti+"&&{admid.P013}EqualIgNull"+@IsUnLimMedSJ+"&&{admid.P014}EqualIgNull"+@IsUnLimMed+"&&{admid.P015}EqualIgNull"+@IsLimMedSJ+"&&{admid.P016}EqualIgNull"+@IsLimMed+"&&{admid.P017}EqualIgNull"+@IsSpMedSJ+"&&{admid.P018}EqualIgNull"+@IsSpMed+"&&{admid.P027}EqualIgNull"+@disDep+")" ';
		} else if (name == "MZ-LOC") {
			kpiObj.kpi = "KP1229,KP1230,KP1231,KP1232,KP1236:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1237:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1238:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1239:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1280:admType^patLoc^ordDoc^itemCat^arcimId";
			kpiObj.kpiNum = 9;
			kpiObj.dim = "CTLOC,Doc,AdmType,IsAnti,IsInject,IsAntiInject,ItemCat,ARCIMID";
			kpiObj.dimNum = 8;
			kpiObj.filterRule = '"KP1229:({admType}=O&&{patLoc}EqualIgNull"+@loc+"),KP1230:({admType}=O&&{patLoc}EqualIgNull"+@loc+"),KP1231:({admType}=O&&{patLoc}EqualIgNull"+@loc+"),KP1232:({admType}=O&&{patLoc}EqualIgNull"+@loc+"),KP1236:({admType}=O&&{ordLoc}EqualIgNull"+@loc+"),KP1237:({admType}=O&&{ordLoc}EqualIgNull"+@loc+"),KP1238:({admType}=O&&{ordLoc}EqualIgNull"+@loc+"),KP1239:({admType}=O&&{ordLoc}EqualIgNull"+@loc+"),KP1280:({admType}=O&&{patLoc}EqualIgNull"+@loc+")"';
		} else if (name == "MZ-DOC") {
			kpiObj.kpi = "KP1229,KP1230,KP1231,KP1232,KP1236:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1237:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1238:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1239:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1280:admType^patLoc^ordDoc^itemCat^arcimId";
			kpiObj.kpiNum = 9;
			kpiObj.dim = "CTLOC,Doc,AdmType,IsAnti,IsInject,IsAntiInject,ItemCat,ARCIMID";
			kpiObj.dimNum = 8;
			kpiObj.filterRule = '"KP1229:({admType}=O&&{patLoc}EqualIgNull"+@loc+"),KP1230:({admType}=O&&{patLoc}EqualIgNull"+@loc+"),KP1231:({admType}=O&&{patLoc}EqualIgNull"+@loc+"),KP1232:({admType}=O&&{patLoc}EqualIgNull"+@loc+"),KP1236:({admType}=O&&{ordLoc}EqualIgNull"+@loc+"),KP1237:({admType}=O&&{ordLoc}EqualIgNull"+@loc+"),KP1238:({admType}=O&&{ordLoc}EqualIgNull"+@loc+"),KP1239:({admType}=O&&{ordLoc}EqualIgNull"+@loc+"),KP1280:({admType}=O&&{patLoc}EqualIgNull"+@loc+")"';
		} else if (name == "JZ-LOC") {
			kpiObj.kpi = "KP1229,KP1230,KP1231,KP1232,KP1236:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1237:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1238:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1239:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1280:admType^patLoc^ordDoc^itemCat^arcimId";
			kpiObj.kpiNum = 9;
			kpiObj.dim = "CTLOC,Doc,AdmType,IsAnti,IsInject,IsAntiInject,ItemCat,ARCIMID";
			kpiObj.dimNum = 8;
			kpiObj.filterRule = '"KP1229:({admType}=E&&{patLoc}EqualIgNull"+@loc+"),KP1230:({admType}=E&&{patLoc}EqualIgNull"+@loc+"),KP1231:({admType}=E&&{patLoc}EqualIgNull"+@loc+"),KP1232:({admType}=E&&{patLoc}EqualIgNull"+@loc+"),KP1236:({admType}=E&&{ordLoc}EqualIgNull"+@loc+"),KP1237:({admType}=E&&{ordLoc}EqualIgNull"+@loc+"),KP1238:({admType}=E&&{ordLoc}EqualIgNull"+@loc+"),KP1239:({admType}=E&&{ordLoc}EqualIgNull"+@loc+"),KP1280:({admType}=E&&{patLoc}EqualIgNull"+@loc+")"';
		} else if (name == "JZ-DOC") {
			kpiObj.kpi = "KP1229,KP1230,KP1231,KP1232,KP1236:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1237:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1238:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1239:admType^ordLoc^ordDoc^isAnti^isInject^isAntiInject,KP1280:admType^patLoc^ordDoc^itemCat^arcimId";
			kpiObj.kpiNum = 9;
			kpiObj.dim = "CTLOC,Doc,AdmType,IsAnti,IsInject,IsAntiInject,ItemCat,ARCIMID";
			kpiObj.dimNum = 8;
			kpiObj.filterRule = '"KP1229:({admType}=E&&{patLoc}EqualIgNull"+@loc+"),KP1230:({admType}=E&&{patLoc}EqualIgNull"+@loc+"),KP1231:({admType}=E&&{patLoc}EqualIgNull"+@loc+"),KP1232:({admType}=E&&{patLoc}EqualIgNull"+@loc+"),KP1236:({admType}=E&&{ordLoc}EqualIgNull"+@loc+"),KP1237:({admType}=E&&{ordLoc}EqualIgNull"+@loc+"),KP1238:({admType}=E&&{ordLoc}EqualIgNull"+@loc+"),KP1239:({admType}=E&&{ordLoc}EqualIgNull"+@loc+"),KP1280:({admType}=E&&{patLoc}EqualIgNull"+@loc+")"';
		} else if (name == "CY-LOC") {
			kpiObj.kpi = "KP1246,KP1247,KP1250,KP1251,KP1259,KP1261,KP1262,KP1267,KP1268,KP1270,KP1271,KP1248";
			kpiObj.kpiNum = 12;
			kpiObj.dim = "WARD,CTLOC,Doc";
			kpiObj.dimNum = 3;
			kpiObj.filterRule = '"KP1246:({disLoc}EqualIgNull"+@loc+"),KP1247:({disLoc}EqualIgNull"+@loc+"),KP1250:({disLoc}EqualIgNull"+@loc+"),KP1251:({disLoc}EqualIgNull"+@loc+"),KP1259:({disLoc}EqualIgNull"+@loc+"),KP1261:({disLoc}EqualIgNull"+@loc+"),KP1262:({disLoc}EqualIgNull"+@loc+"),KP1267:({disLoc}EqualIgNull"+@loc+"),KP1268:({disLoc}EqualIgNull"+@loc+"),KP1270:({disLoc}EqualIgNull"+@loc+"),KP1271:({disLoc}EqualIgNull"+@loc+"),KP1248:({disLoc}EqualIgNull"+@loc+")"';
		} else if (name == "CY-DOC") {
			kpiObj.kpi = "KP1246,KP1247,KP1250,KP1251,KP1259,KP1261,KP1262,KP1267,KP1268,KP1270,KP1271,KP1248";
			kpiObj.kpiNum = 12;
			kpiObj.dim = "WARD,CTLOC,Doc";
			kpiObj.dimNum = 3;
			kpiObj.filterRule = '"KP1246:({disLoc}EqualIgNull"+@loc+"),KP1247:({disLoc}EqualIgNull"+@loc+"),KP1250:({disLoc}EqualIgNull"+@loc+"),KP1251:({disLoc}EqualIgNull"+@loc+"),KP1259:({disLoc}EqualIgNull"+@loc+"),KP1261:({disLoc}EqualIgNull"+@loc+"),KP1262:({disLoc}EqualIgNull"+@loc+"),KP1267:({disLoc}EqualIgNull"+@loc+"),KP1268:({disLoc}EqualIgNull"+@loc+"),KP1270:({disLoc}EqualIgNull"+@loc+"),KP1271:({disLoc}EqualIgNull"+@loc+"),KP1248:({disLoc}EqualIgNull"+@loc+")"';
		} else if (name == "XJ-NY") {
			kpiObj.kpi = "KP1304:orgWcode^antWCode^ctloc^sen";
			kpiObj.kpiNum = 1;
			kpiObj.dim = "OrgCode,AntCode,CTLOC,Sen";
			kpiObj.dimNum = 4;
			kpiObj.filterRule = '"KP1304:({orgWcode}EqualIgNull"+@orgcode+")"';
		} else if (name == "XJ-LOC") {
			kpiObj.kpi = "KP1304:orgWcode^antWCode^ctloc^sen";
			kpiObj.kpiNum = 1;
			kpiObj.dim = "OrgCode,AntCode,CTLOC,Sen";
			kpiObj.dimNum = 4;
			kpiObj.filterRule = '"KP1304:({orgWcode}EqualIgNull"+@orgcode+")"';
		} else if (name == "XJ-INFO") {
			kpiObj.kpi = "KP1304:orgWcode^antWCode^ctloc^sen";
			kpiObj.kpiNum = 1;
			kpiObj.dim = "OrgCode,AntCode,CTLOC,Sen";
			kpiObj.dimNum = 4;
			kpiObj.filterRule = '"KP1304:({orgWcode}EqualIgNull"+@orgcode+"&&{ctloc}EqualIgNull"+@loc+")"';
		} else if (name == "XH-KJY") {
			kpiObj.kpi = "<i class='c-kpi'>KP1240</i>:admType^ordLoc^ordDoc^arcimId.P002^arcimId.P008^arcimId.P009^arcimId.P010^arcimId.P011^arcimId.P012^arcimId.P013,<br>" +
						"<i class='c-kpi'>KP1241</i>:admType^ordLoc^ordDoc^arcimId.P002^arcimId.P008^arcimId.P009^arcimId.P010^arcimId.P011^arcimId.P012^arcimId.P013,<br>" +
						"<i class='c-kpi'>KP1242</i>:admType^ordLoc^ordDoc^arcimId.P002^arcimId.P008^arcimId.P009^arcimId.P010^arcimId.P011^arcimId.P012^arcimId.P013,<br>" +
						"<i class='c-kpi'>KP1243</i>:admType^ordLoc^ordDoc^ordType^arcimId.P002^arcimId.P008^arcimId.P009^arcimId.P010^arcimId.P011^arcimId.P012^arcimId.P013,<br>" +
						"<i class='c-kpi'>KP1244</i>:admType^ordLoc^ordDoc^ordType^arcimId.P002^arcimId.P008^arcimId.P009^arcimId.P010^arcimId.P011^arcimId.P012^arcimId.P013,<br>" +
						"<i class='c-kpi'>KP1245</i>:admType^ordLoc^ordDoc^ordType^arcimId.P002^arcimId.P008^arcimId.P009^arcimId.P010^arcimId.P011^arcimId.P012^arcimId.P013";

			kpiObj.kpiNum = 6;
			kpiObj.dim = "admType^ordLoc^ordDoc^arcimId.P002^arcimId.P008^arcimId.P009^arcimId.P010^arcimId.P011^arcimId.P012^arcimId.P013^ordType";
			kpiObj.dimNum = 11;
			kpiObj.filterRule = '"KP1240:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1241:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1242:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1243:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1244:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1245:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+")"';
		} else if (name == "XH-YL") {
			kpiObj.kpi = "<i class='c-kpi'>KP1240</i>:admType^ordLoc^ordDoc^arcimId.P002^arcimId.P008^arcimId.P009,<br>" +
						"<i class='c-kpi'>KP1241</i>:admType^ordLoc^ordDoc^arcimId.P002^arcimId.P008^arcimId.P009,<br>" +
						"<i class='c-kpi'>KP1242</i>:admType^ordLoc^ordDoc^arcimId.P002^arcimId.P008^arcimId.P009,<br>" +
						"<i class='c-kpi'>KP1243</i>:admType^ordLoc^ordDoc^ordType^arcimId.P002^arcimId.P008^arcimId.P009,<br>" +
						"<i class='c-kpi'>KP1244</i>:admType^ordLoc^ordDoc^ordType^arcimId.P002^arcimId.P008^arcimId.P009,<br>" +
						"<i class='c-kpi'>KP1245</i>:admType^ordLoc^ordDoc^ordType^arcimId.P002^arcimId.P008^arcimId.P009";
			kpiObj.kpiNum = 6;
			kpiObj.dim = "admType^ordLoc^ordDoc^arcimId.P002^arcimId.P008^arcimId.P009^ordType";
			kpiObj.dimNum = 7;
			kpiObj.filterRule = '"KP1240:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1241:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1242:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1243:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1244:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+"),KP1245:({arcimId.P002}=1&&{ordLoc}EqualIgNull"+@loc+"&&{arcimId.P009}EqualIgNull"+@drugname+")"';
		} 
		else {
			return false;
		}
		var 
			content = '<div class="row">' +
					'<div class="col-xs-2 c-col-left">指标个数：</div>' +
						'<div class="col-xs-10 c-col-right">' + kpiObj.kpiNum + '</div>' +
					'</div>' +
				'<div class="row">' +
            		'<div class="col-xs-2 c-col-left">指标顺序：</div>' + 
            			'<div class="col-xs-10 c-col-right">' + kpiObj.kpi + '</div>' +
            		'</div>' +
            	'<div class="row">' +
					'<div class="col-xs-2 c-col-left">维度列数：</div>' +
            		'<div class="col-xs-10 c-col-right">' + kpiObj.dimNum + '</div>' +
            	'</div>' +
            	'<div class="row">' +
            		'<div class="col-xs-2 c-col-left">维度顺序：</div>' +
            		'<div class="col-xs-10 c-col-right">' + kpiObj.dim + '</div>' +
            	'</div>' +
				'<div class="row">' +
					'<div class="col-xs-2 c-col-left">过滤规则：</div>' +
            		'<div class="col-xs-10 c-col-right">' + kpiObj.filterRule + '</div>' +
            	'</div><hr>';
		kpiObj.content = content;
		return true;
	};
	
	var addKPI = function(selector, name) {
		if ((name) && (name != "")) {
			$(selector).after($(kpiObj.content));
		};
	};
	 
	$(".c-add").each(function(index, ele){
		var name = $(this).attr('name');
		var result = setKPI(name);
		if (result) addKPI(this, name);
	});
	 
 })