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
