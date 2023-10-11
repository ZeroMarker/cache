var episodeIDs=[1624,52,73,44,280,71,41,72,38,292,422,781,533,1437,441,799,998,999,1457,1571,2650,322,1897,1246,1721,2068,2573,1770,293];
var text,xmlDoc;
function printTest() {
	text=getWristbandXmlcodeByCode("DHCWristStraps");
	try { //Internet Explorer
	  xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
	  xmlDoc.async="false";
	  xmlDoc.loadXML(text);
	} catch(e) {
	  try { //Firefox, Mozilla, Opera, etc.
	    parser=new DOMParser();
	    xmlDoc=parser.parseFromString(text,"text/xml");
	  } catch(e) {
	  	alert(e.message);
	  }
	}
	console.log(xmlDoc);
	var txtdatapara=xmlDoc.querySelectorAll("txtdatapara");
	txtdatapara=Array.from(txtdatapara);
	console.log(txtdatapara);
	// txtdatapara.map(function(t) {
	// 	var name=t.getAttribute("name")
	// 	console.log(name);
	// })
	// return;
	var LODOP = getLodop();
	var COL=2,ROW=15; //设置打印的行数列数
	var colwidth=600/COL,rowheight=1050/ROW; //列宽，行高
	var n=0;
	var sep=String.fromCharCode(2);
	var ratio=3.78;
	var yratio2=2.7;
	var xratio2=3.3;
	episodeIDs.map(function(episodeID) {
		$m({
			ClassName: "Nur.NIS.Service.OrderExcute.Print",
			MethodName: "WristStraps",
	    dataType: "text",
			episodeID: episodeID
		},function(d) {
			console.log('*************************');
			console.log(n);
			if (n==(COL*ROW)) LODOP.NEWPAGE();
			d=d.split("^");
			var pat={};
			d.map(function(e) {
				var es=e.split(sep);
				pat[es[0]]=es[1];
			});
			var row=Math.floor(n/COL)%ROW,col=n%COL;
			txtdatapara.map(function(t) {
				var fontSize=t.getAttribute("fontsize");
				var fontname=t.getAttribute("fontname");
				var fontbold="true"==t.getAttribute("fontbold")?1:0;
				var yrow=t.getAttribute("yrow");
				yrow=parseFloat(yrow)*yratio2;
				var xcol=t.getAttribute("xcol");
				xcol=parseFloat(xcol)*xratio2;
				var defaultvalue=t.getAttribute("defaultvalue");
				if ("true"==t.getAttribute("isqrcode")) {
					// 打印二维码
					LODOP.ADD_PRINT_BARCODE(
						yrow+rowheight*row,
						xcol+colwidth*col,
						t.getAttribute("width")*ratio,
						t.getAttribute("height")*ratio,
						"QRCode",
						pat[t.getAttribute("name")]
					);
				} else {
				  LODOP.ADD_PRINT_TEXT(
						yrow+rowheight*row,
						xcol+colwidth*col,
						1000,
						"",
						defaultvalue||pat[t.getAttribute("name")]
				  );
				  LODOP.SET_PRINT_STYLEA(0, "FontName", fontname);
				  LODOP.SET_PRINT_STYLEA(0, "FontSize", fontSize);
				  LODOP.SET_PRINT_STYLEA(0, "bold", fontbold);
				}
			})
			n++;
		});
	})
	var timer = setInterval(function(){
		console.log('-----------------------');
		console.log(n);
		console.log(episodeIDs.length);
		if(n==episodeIDs.length) {
			clearInterval(timer);
		  LODOP.PREVIEW();
		}
	},100);
}
function getWristbandXmlcodeByCode(code) {
	var xmlCode = $m({
		ClassName: "Nur.NIS.Service.OrderExcute.Print",
		MethodName: "GetWristbandXmlcodeByCode",
    dataType: "text",
		Code: code
	},false);
	return xmlCode;
}