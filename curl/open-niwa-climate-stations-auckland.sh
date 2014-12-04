# Example script to use CURL to get data from the NIWA Stations WFS service.

# Cut and paste the server URL here
server_url="http://dc.niwa.co.nz/gs/stations/wms"
echo $server_url

# paste the WFS Request body between the EOF markers.
# this example counts open NIWA Climate Stations in the Auckland Area
# replace 'results' with 'hits' to get the count
read -d '' wfs_request <<"EOF"
<wfs:GetFeature xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    service="WFS"
    version="1.1.0"
    xsi:schemaLocation="http://www.opengis.net/wfs http://schemas.opengis.net/wfs/1.1.0/wfs.xsd"
    resultType="results">
  <wfs:Query xmlns:feature="http://niwa.co.nz/ns/niwa"
    typeName="feature:stations_180"
    srsName="EPSG:4326">
    <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:And>
        <ogc:And>
          <ogc:PropertyIsLike matchCase="false" wildCard="*" singleChar="." escapeChar="!">
            <ogc:PropertyName>types</ogc:PropertyName>
            <ogc:Literal>*Climate*</ogc:Literal>
          </ogc:PropertyIsLike>
          <ogc:PropertyIsLike matchCase="false" wildCard="*" singleChar="." escapeChar="!">
            <ogc:PropertyName>organisation</ogc:PropertyName>
            <ogc:Literal>*National Institute of Water and Atmospheric Research*</ogc:Literal>
          </ogc:PropertyIsLike>
        </ogc:And>
        <ogc:And>
          <ogc:PropertyIsBetween>
            <ogc:PropertyName>start_date</ogc:PropertyName>
            <ogc:LowerBoundary>
              <ogc:Literal>1800-01-01</ogc:Literal>
            </ogc:LowerBoundary>
            <ogc:UpperBoundary>
              <ogc:Literal>2014-11-20</ogc:Literal>
            </ogc:UpperBoundary>
          </ogc:PropertyIsBetween>
          <ogc:PropertyIsGreaterThanOrEqualTo>
            <ogc:PropertyName>end_date</ogc:PropertyName>
            <ogc:Literal>2014-10-22</ogc:Literal>
          </ogc:PropertyIsGreaterThanOrEqualTo>
        </ogc:And>
        <ogc:Intersects>
          <ogc:PropertyName>geom</ogc:PropertyName>
            <gml:Polygon xmlns:gml="http://www.opengis.net/gml">
              <gml:exterior><gml:LinearRing>
                <gml:posList>
                174.44380159999997 -37.0654751
                174.44380159999997 -36.66057100000001
                175.28713709999997 -36.66057100000001
                175.28713709999997 -37.0654751
                174.44380159999997 -37.0654751
                </gml:posList>
              </gml:LinearRing>
            </gml:exterior>
          </gml:Polygon>
        </ogc:Intersects>
      </ogc:And>
    </ogc:Filter>
  </wfs:Query>
</wfs:GetFeature>
EOF

# run curl to fetch the data,  The result will be sent to the console
curl --header "Content-Type: text/xml" -d "$wfs_request" $server_url

# to send to a file call with
# stations-wfs.sh > stations.xml
