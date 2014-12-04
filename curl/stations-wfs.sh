# Example script to use CURL to get data from the NIWA Stations WFS service.

# Cut and paste the server URL here
server_url="http://dc.niwa.co.nz/gs/stations/wms"
echo $server_url

# paste the WFS Request body between the EOF markers.
# this example counts 'hits' in the given polygon.
read -d '' wfs_request <<"EOF"
<wfs:GetFeature xmlns:wfs="http://www.opengis.net/wfs"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  service="WFS" version="1.1.0"
  xsi:schemaLocation="http://www.opengis.net/wfs
  http://schemas.opengis.net/wfs/1.1.0/wfs.xsd"
  resultType="hits"
  >
  <wfs:Query xmlns:feature="http://niwa.co.nz/ns/niwa"
    typeName="feature:stations_180"
    srsName="EPSG:4326"
    outputFormat="application/json"
    >
    <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:And>
        <ogc:Intersects>
          <ogc:PropertyName>geom</ogc:PropertyName>
            <gml:Polygon xmlns:gml="http://www.opengis.net/gml">
              <gml:exterior>
                <gml:LinearRing>
                  <gml:posList>
                    173.72510510253395 -37.502258810349204
                    173.72510510253395 -36.29204537516587
                    175.88941174315585 -36.29204537516587
                    175.88941174315585 -37.502258810349204
                    173.72510510253395 -37.502258810349204
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
