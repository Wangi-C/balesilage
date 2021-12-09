<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/jsp/util/top.jsp"/>

<script>
    function checkAccount() {
        if(${accountErrorMsg != null}) {
            window.alert('${accountErrorMsg}');
        }
    }
</script>

<div class="preloader" style="display: none; font-family: 'Nanum Gothic', sans-serif">
    <img src="/assets/images/loader.png" class="preloader__image" alt="">
</div><!-- /.preloader -->

<div class="page-wrapper">
    <div class="site-header__header-one-wrap">
        <header class="main-nav__header-one"></header>
    </div>

    <section class="page-header" style="background-image: url(/assets/images/backgrounds/page-header-contact.jpg);">
        <div class="container">
            <h4 style="font-family: 'Nanum Gothic', sans-serif; text-align: center; padding-bottom: 7%; color: #fefefe ">곤포 사일리지 찾아보기</h4>
        </div>
    </section>

    <section class="contact_google_map_1">
        <div class="row">
            <div class="col-xl-12">
                <div class="showing-result-shorting">
                    <div class="right">
                        <div class="shorting" style="position: absolute; right: 0; width: 15%; margin: 1%; margin-right: 4%;">
                            <div class="dropdown bootstrap-select">
                                <select class="selectpicker" name="orderSelect" id="order" data-width="100%" tabindex="-98">
                                    <option value="" selected="selected">-선택-</option>
                                    <option value="unitP1">단가 낮은순</option>
                                    <option value="unitP2">단가 높은순</option>
                                    <option value="count1">개수 낮은순</option>
                                    <option value="count2">개수 높은순</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div id="map" style="margin-left: 4%; margin-top: 2%; width:700px;height:800px;font-family: 'Nanum Gothic', sans-serif"></div>

            <section class="cart" style="font-family: 'Nanum Gothic', sans-serif">
                <div class="container">
                    <div class="row" style="margin-right: 4%; margin-top: 4%; height: 800px; width: 1100px">
                        <div class="col-xl-12">
                            <table class="cart_table">
                                <thead class="cart_table_head">
                                <tr>
                                    <th colspan="1" style="text-align: center;font-family: 'Nanum Gothic', sans-serif; font-size: 20px">판매자</th>
                                    <th colspan="1" style="text-align: center;font-family: 'Nanum Gothic', sans-serif; font-size: 20px">무게</th>
                                    <th colspan="1" style="text-align: center;font-family: 'Nanum Gothic', sans-serif; font-size: 20px">개수</th>
                                    <th colspan="1" style="text-align: center;font-family: 'Nanum Gothic', sans-serif; font-size: 20px">단가</th>
                                    <th colspan="1" style="text-align: center;font-family: 'Nanum Gothic', sans-serif; font-size: 20px">가격</th>
                                    <th colspan="1" style="text-align: center;font-family: 'Nanum Gothic', sans-serif; font-size: 20px">비고</th>
                                </tr>
                                </thead>
                            </table>
                            <div id="silageList" style="position:relative; width:100%; height:700px; overflow-y:auto; overflow-x:auto;"></div>
                        </div>
                    </div>

                    <!-- 페이징 -->
                    <div id="pagingHtml"></div>

                    <div class="row">
                        <div class="col-xl-11">
                            <div class="button_box">
                                <script>
                                    checkAccount();
                                </script>
                                <a href="/bsa/silages/form">
                                    <button class="thm-btn checkout_btn" type="button" onclick="needLogin()"
                                            style="width: 400px">내 곤포 사일리지 등록하기
                                    </button>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </section>

<%--지도 조회--%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d0b4825b8dca8223449db80faff26514&libraries=services"></script>
<script>
    var mapContainer = document.getElementById('map'),
        mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667),
            level: 8
        };

    var map = new kakao.maps.Map(mapContainer, mapOption);
    var geocoder = new kakao.maps.services.Geocoder();

    var firstPlace;

    if(${member.address != null}) {
        geocoder.addressSearch('${member.address}', function (result, status) {
            if(status === kakao.maps.services.Status.OK) {
                firstPlace = new kakao.maps.LatLng(result[0].y, result[0].x);
            }
        });
    }

    <c:forEach items="${silages}" var="silage">
    geocoder.addressSearch('${silage.address}', function(result, status) {

        // 정상적으로 검색이 완료됐으면
        if (status === kakao.maps.services.Status.OK && ${fn:contains(silage.transactionStatus,'Y')} ) {

            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            // 결과값으로 받은 위치를 마커로 표시합니다
            var marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });

            // 인포윈도우로 장소에 대한 설명을 표시합니다
            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="width:150px;text-align:center;padding:6px 0;">${silage.id}</div>'
            });
            infowindow.open(map, marker);

            if(${member.address == null}) {
                map.setCenter(coords);
            } else {
                map.setCenter(firstPlace);
            }
        }
    });
    </c:forEach>

    </script>
    <script>
        var selectEvent = document.getElementById("order");
        selectEvent.addEventListener('change', initPage);
        selectEvent.addEventListener('change', search);

        var pageNo = 0;
        search();

        function initPage() {
            pageNo = 0;
        }

        function changePage(pageButtonId) {
            pageNo = parseInt(pageButtonId);

            search();
        }

        function search() {
            var searchKeyword = {
                pageNo : pageNo
                , orderStandard : document.getElementById("order").value
            };

            $.ajax({
                url: "${pageContext.request.contextPath}/bsa/silages/list",
                type: "POST",
                data: JSON.stringify(searchKeyword),
                headers: {"Content-Type": "application/json;charset=UTF-8"},
                success: function (rows) {
                    drawTable(rows);
                }
            })
        }

        function drawTable(rows) {
            // if(rows.member != null) {
            //     var member = rows.member;
            // }
            var showData = rows.silages;
            var navigatorHtml = rows.navigator;

            var script = "";

            script += "<table class=\"cart_table\">";

            script += "    <tbody>";
            for (var i = 0; i < showData.length; i++) {

                if (showData[i].transactionStatus == 'Y') {
                    script += "    <tr>";
                    script += "        <div><td style=\"text-align: center\"><input type=\"hidden\" id=\"memberId\" value=\"" + showData[i].id + "\">" + showData[i].id + "</td></div>";
                    script += "        <div><td style=\"text-align: right\">" + showData[i].weight + "</td></div>";
                    script += "        <div><td style=\"text-align: right\">" + showData[i].count + "</td></div>";
                    script += "        <div><td style=\"text-align: right\">" + showData[i].unitPrice + "</td></div>";
                    script += "        <div><td style=\"text-align: right\">" + (showData[i].count * showData[i].unitPrice) + "</td></div>";
                    script += "        <div class=\"row\" style=\"text-align: center\">";
                    script += "            <td style=\"text-align: right\"><input type=\"button\" value=\"위치보기\" onclick=\"viewLocation(\'" + showData[i].id + "\')\"><br>";
                    script += "                <a href=\"/bsa/silages/" + showData[i].silageCode + "\" onclick=needLogin()><input type=\"button\" value=\"상세조회\" ></a>";
                    script += "            </td>";
                    script += "        </div>";
                    script += "    </tr>";
                }
            }
            script += "    </tbody>";

            script += "</table>";

            $("#pagingHtml").html(navigatorHtml);
            $("#silageList").html(script);
        }
    </script>
    <script>


        function viewLocation(x) {
            var xmlHttp = new XMLHttpRequest();
            var member = {
                id: x
            };

            var parseMember = JSON.stringify(member);
            var silageLocation;

            xmlHttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    let location = xmlHttp.response;

                    silageLocation = location.address;

                    geocoder.addressSearch(silageLocation, function (result, status) {
                        // 정상적으로 검색이 완료됐으면
                        if (status === kakao.maps.services.Status.OK) {

                            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                            map.setCenter(coords);
                        }
                    });
                }
            }

            xmlHttp.open('POST', 'http://localhost/bsa/silages/place');
            xmlHttp.responseType = 'json';
            xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
            xmlHttp.send(parseMember);

            console.log(typeof silageLocation)


        }
    </script>

<jsp:include page="/WEB-INF/jsp/util/bottom.jsp"/>