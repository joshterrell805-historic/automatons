# for cprovider in CProvider

  # if MProviders if empty
    # create new master record with cprovider
    # continue

  # for mprovider in MProvider
    # establishing confidence for each cprovider-mprovider using all match rules

  # select highest confidence

  # if confidence >= threshold
    # merge cprovider with mprovider
    # logging which rules passed
  # else
    # create new master record with cprovider
#
# And in Ruby...
THRESHOLD = 0 # Set this to the threshold
CProvider.each do |cprovider|
  # This is assuming MProviders is an array
  if MProviders.empty?
    create_master_record cprovider
    next
  end

  MProviders.each do |mprovider|
    # establish confidence confidence
    # select highest confidence
    if confidence >= THRESHOLD
      merge_records mprovider, cprovider
      log_merge mprovider, cprovider
      # Although perhaps this would be in the merge_records
    else
      add_new_mprovider
    end
  end
end
