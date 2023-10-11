// var testDatas = dhccl.getDatas(ANCSP.DataQuery, {
    //     ClassName: "DHCAN.BLL.TestTemp",
    //     QueryName: "FindStockTestData",
    //     ArgCnt: 0
    // }, "json");
    // var htmlArr = [];

    // for (var j = 0; j < 20; j++) {
    //     htmlArr.length = 0;
    //     htmlArr.push("<table><thead><tr>");
    //     htmlArr.push("<th>SeqNo</th><th>Col1</th><th>Col2</th><th>Col3</th><th>Col4</th><th>Col5</th>");
    //     htmlArr.push("<th>Col6</th><th>Col7</th><th>Col8</th><th>Col9</th><th>Col10</th></tr></thead>");
    //     htmlArr.push("<tbody>");
    //     for (var i = 0; i < 500; i++) {
    //         if ((j * 500 + i) >= testDatas.length) break;
    //         htmlArr.push("<tr>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].SeqNo+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col1+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col2+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col3+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col4+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col5+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col6+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col7+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col8+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col9+"</td>");
    //         htmlArr.push("<td>"+testDatas[j*500+i].Col10+"</td>");
    //         htmlArr.push("</tr>");
    //     }
    //     htmlArr.push("</tbody></table>");
    //     lodop.ADD_PRINT_TABLE(10,10,"100%","100%",htmlArr.join(""));
    //     lodop.PRINT();
    // }
    // var testDatas = dhccl.getDatas(ANCSP.DataQuery, {
    //     ClassName: "DHCAN.BLL.TestTemp",
    //     QueryName: "FindStockTestData",
    //     ArgCnt: 0
    // }, "json");
    // var htmlArr = [];
    // htmlArr.push("<table border=1 cellSpacing=0 cellPadding=1><thead><tr>");
    // htmlArr.push("<th>SeqNo</th><th>Col1</th><th>Col2</th><th>Col3</th><th>Col4</th><th>Col5</th>");
    // htmlArr.push("<th>Col6</th><th>Col7</th><th>Col8</th><th>Col9</th><th>Col10</th></tr></thead>");
    // htmlArr.push("<tbody>");
    // for (var j = 0; j < testDatas.length; j++) {

    //     htmlArr.push("<tr>");
    //     htmlArr.push("<td>" + testDatas[j].SeqNo + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col1 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col2 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col3 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col4 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col5 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col6 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col7 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col8 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col9 + "</td>");
    //     htmlArr.push("<td>" + testDatas[j].Col10 + "</td>");
    //     htmlArr.push("</tr>");

    // }
    // htmlArr.push("</tbody></table>");
    // lodop.ADD_PRINT_TABLE(10, 10, "100%", "100%", htmlArr.join(""));
    // lodop.PRINT();