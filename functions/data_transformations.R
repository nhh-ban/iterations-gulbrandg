# Function to transform metadata
transform_metadata_to_df <- function(meta_data) {
  df <-
    meta_data$trafficRegistrationPoints %>%  
    map(as_tibble) %>%  # Make tibble
    bind_rows() %>% # Do for all rows simultaneous
    mutate(location = map(location, unlist)) %>%   # Unlist the two location variables
    mutate(
      lat = map_dbl(location, "latLon.lat"), # Find latitude
      lon = map_dbl(location, "latLon.lon"), # Find longitude
      location = NULL) %>% # Remove old location column
    mutate(latestData = map_chr(latestData, 1, .default = ""))  %>%  # Get character of datetime
    mutate(latestData = as_datetime(latestData, tz = "UTC")) # Convert to datetime
  df
}

# Function to transform volume data
transform_volume_data <- function(volume_data) {
  df <-
    volume_data$trafficData$volume$byHour$edges %>% 
    map({\(x) as_tibble(x[[1]])}) %>%  # Function to select each correct value from lists that are nested
    list_rbind() %>% # Do for all elements simultaneous 
    mutate(volume = map_int(total, 1, .default = NA), # Find integer for nested list containing volume
           total = NULL) # Remove nested list column
  df
}

# Function to offset date and add a 'Z'
to_iso8601 <- function(date.time, offset) {
  date <- 
    (date.time + days(offset)) %>%  # Make the offset
    iso8601(.) %>% # Make to iso8601 format
    as.character() %>%# Convert to character
    paste0(., "Z") # Add a 'Z' to the end
  return(date)
}


