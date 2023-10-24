# Function to create query with costom id and timestamps
vol_qry <- function(id, from, to){
  query <- sprintf("{
    trafficData(trafficRegistrationPointId: \"%s\") { 
      volume {
        byHour(from: \"%s\", to: \"%s\") {
          edges {
            node {
              from
              to
              total {
                volumeNumbers {
                  volume
                }
              }
            }
          }
        }
      }
    }
  }", id, from, to) # Insert id and timestamps where it says \"%s\
  query 
}